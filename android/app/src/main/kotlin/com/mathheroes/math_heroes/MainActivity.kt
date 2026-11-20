package com.mathheroes.math_heroes

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.provider.DocumentsContract
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

// local_auth needs a FragmentActivity host on Android; using FlutterActivity
// makes every biometric prompt fail with a "no_fragment_activity" error.
class MainActivity : FlutterFragmentActivity() {
    private val channelName = "math_heroes/saf_backup"
    private val requestPickDirectory = 9101
    private var pendingPickResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "pickDirectory" -> pickDirectory(result)
                    "listBackups" -> {
                        val treeUri = call.argument<String>("treeUri")
                        if (treeUri == null) {
                            result.error("ARG", "treeUri required", null)
                        } else {
                            try {
                                result.success(listBackups(treeUri))
                            } catch (e: Exception) {
                                result.error("LIST", e.message, null)
                            }
                        }
                    }
                    "createBackup" -> {
                        val treeUri = call.argument<String>("treeUri")
                        val fileName = call.argument<String>("fileName")
                        val sourcePath = call.argument<String>("sourcePath")
                        if (treeUri == null || fileName == null || sourcePath == null) {
                            result.error("ARG", "treeUri,fileName,sourcePath required", null)
                        } else {
                            try {
                                result.success(createBackup(treeUri, fileName, sourcePath))
                            } catch (e: Exception) {
                                result.error("CREATE", e.message, null)
                            }
                        }
                    }
                    "readToCache" -> {
                        val uri = call.argument<String>("uri")
                        val cacheName = call.argument<String>("cacheName")
                        if (uri == null || cacheName == null) {
                            result.error("ARG", "uri,cacheName required", null)
                        } else {
                            try {
                                result.success(readToCache(uri, cacheName))
                            } catch (e: Exception) {
                                result.error("READ", e.message, null)
                            }
                        }
                    }
                    "deleteDocument" -> {
                        val uri = call.argument<String>("uri")
                        if (uri == null) {
                            result.error("ARG", "uri required", null)
                        } else {
                            try {
                                result.success(deleteDocument(uri))
                            } catch (e: Exception) {
                                result.error("DELETE", e.message, null)
                            }
                        }
                    }
                    "getPersistedPermissions" -> {
                        result.success(contentResolver.persistedUriPermissions.map {
                            mapOf(
                                "uri" to it.uri.toString(),
                                "read" to it.isReadPermission,
                                "write" to it.isWritePermission
                            )
                        })
                    }
                    "releasePermission" -> {
                        val uri = call.argument<String>("uri")
                        if (uri != null) {
                            try {
                                val parsed = Uri.parse(uri)
                                contentResolver.releasePersistableUriPermission(
                                    parsed,
                                    Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                                )
                            } catch (_: Exception) {}
                        }
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun pickDirectory(result: MethodChannel.Result) {
        if (pendingPickResult != null) {
            result.error("BUSY", "Another pick in progress", null)
            return
        }
        pendingPickResult = result
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).apply {
            addFlags(
                Intent.FLAG_GRANT_READ_URI_PERMISSION or
                    Intent.FLAG_GRANT_WRITE_URI_PERMISSION or
                    Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION or
                    Intent.FLAG_GRANT_PREFIX_URI_PERMISSION
            )
        }
        @Suppress("DEPRECATION")
        startActivityForResult(intent, requestPickDirectory)
    }

    @Deprecated("Deprecated in Java")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != requestPickDirectory) return
        val res = pendingPickResult ?: return
        pendingPickResult = null
        if (resultCode != Activity.RESULT_OK || data?.data == null) {
            res.success(null)
            return
        }
        val uri = data.data!!
        val flags = (data.flags and
            (Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION))
        try {
            contentResolver.takePersistableUriPermission(uri, flags)
        } catch (_: Exception) {
            // Best effort; may already be persisted.
        }
        res.success(mapOf("uri" to uri.toString(), "name" to (treeDisplayName(uri) ?: uri.lastPathSegment)))
    }

    private fun treeDisplayName(uri: Uri): String? {
        return try {
            val docUri = DocumentsContract.buildDocumentUriUsingTree(
                uri, DocumentsContract.getTreeDocumentId(uri)
            )
            contentResolver.query(docUri, arrayOf(DocumentsContract.Document.COLUMN_DISPLAY_NAME), null, null, null)
                ?.use { c -> if (c.moveToFirst()) c.getString(0) else null }
        } catch (_: Exception) { null }
    }

    private fun listBackups(treeUriString: String): List<Map<String, Any?>> {
        val treeUri = Uri.parse(treeUriString)
        val docId = DocumentsContract.getTreeDocumentId(treeUri)
        val childrenUri = DocumentsContract.buildChildDocumentsUriUsingTree(treeUri, docId)
        val projection = arrayOf(
            DocumentsContract.Document.COLUMN_DOCUMENT_ID,
            DocumentsContract.Document.COLUMN_DISPLAY_NAME,
            DocumentsContract.Document.COLUMN_SIZE,
            DocumentsContract.Document.COLUMN_LAST_MODIFIED,
            DocumentsContract.Document.COLUMN_MIME_TYPE
        )
        val out = mutableListOf<Map<String, Any?>>()
        contentResolver.query(childrenUri, projection, null, null, null)?.use { cursor ->
            val idIdx = cursor.getColumnIndex(DocumentsContract.Document.COLUMN_DOCUMENT_ID)
            val nameIdx = cursor.getColumnIndex(DocumentsContract.Document.COLUMN_DISPLAY_NAME)
            val sizeIdx = cursor.getColumnIndex(DocumentsContract.Document.COLUMN_SIZE)
            val modIdx = cursor.getColumnIndex(DocumentsContract.Document.COLUMN_LAST_MODIFIED)
            while (cursor.moveToNext()) {
                val name = if (nameIdx >= 0) cursor.getString(nameIdx) ?: "" else ""
                if (!name.startsWith("math_heroes_backup_") || !name.endsWith(".sqlite")) continue
                val docIdVal = if (idIdx >= 0) cursor.getString(idIdx) else continue
                val docUri = DocumentsContract.buildDocumentUriUsingTree(treeUri, docIdVal)
                val size = if (sizeIdx >= 0 && !cursor.isNull(sizeIdx)) cursor.getLong(sizeIdx) else 0L
                val modified = if (modIdx >= 0 && !cursor.isNull(modIdx)) cursor.getLong(modIdx) else 0L
                out.add(
                    mapOf(
                        "uri" to docUri.toString(),
                        "name" to name,
                        "size" to size,
                        "lastModified" to modified
                    )
                )
            }
        }
        return out
    }

    private fun createBackup(treeUriString: String, fileName: String, sourcePath: String): Map<String, Any?> {
        val treeUri = Uri.parse(treeUriString)
        val docId = DocumentsContract.getTreeDocumentId(treeUri)
        val parentUri = DocumentsContract.buildDocumentUriUsingTree(treeUri, docId)
        val created = DocumentsContract.createDocument(
            contentResolver, parentUri, "application/x-sqlite3", fileName
        ) ?: throw IllegalStateException("تعذر إنشاء ملف النسخة في المجلد المختار.")
        contentResolver.openOutputStream(created)?.use { out ->
            File(sourcePath).inputStream().use { input -> input.copyTo(out) }
        } ?: throw IllegalStateException("تعذر كتابة النسخة الاحتياطية.")
        // Best-effort size
        var size = 0L
        var modified = System.currentTimeMillis()
        contentResolver.query(created, arrayOf(DocumentsContract.Document.COLUMN_SIZE, DocumentsContract.Document.COLUMN_LAST_MODIFIED), null, null, null)?.use { c ->
            if (c.moveToFirst()) {
                if (!c.isNull(0)) size = c.getLong(0)
                if (!c.isNull(1)) modified = c.getLong(1)
            }
        }
        if (size == 0L) size = File(sourcePath).length()
        return mapOf("uri" to created.toString(), "name" to fileName, "size" to size, "lastModified" to modified)
    }

    private fun readToCache(uriString: String, cacheName: String): String {
        val uri = Uri.parse(uriString)
        val safeName = cacheName.replace(Regex("[^A-Za-z0-9._-]"), "_")
        val outFile = File(cacheDir, safeName)
        contentResolver.openInputStream(uri)?.use { input ->
            FileOutputStream(outFile).use { output -> input.copyTo(output) }
        } ?: throw IllegalStateException("تعذر قراءة النسخة الاحتياطية.")
        return outFile.absolutePath
    }

    private fun deleteDocument(uriString: String): Boolean {
        return try {
            DocumentsContract.deleteDocument(contentResolver, Uri.parse(uriString))
        } catch (e: Exception) {
            false
        }
    }
}

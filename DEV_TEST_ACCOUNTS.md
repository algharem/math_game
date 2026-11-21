# Development / testing student accounts

Nine shared students are seeded so the app can be exercised across every
supported grade without creating accounts by hand.

| Username | Student name | Grade | Password |
|---|---|---|---:|---|
| `student1` | Student 1 | 1 | `111111` |
| `student2` | Student 2 | 2 | `111111` |
| `student3` | Student 3 | 3 | `111111` |
| `student4` | Student 4 | 4 | `111111` |
| `student5` | Student 5 | 5 | `111111` |
| `student6` | Student 6 | 6 | `111111` |
| `student7` | Student 7 | 7 | `111111` |
| `student8` | Student 8 | 8 | `111111` |
| `student9` | Student 9 | 9 | `111111` |

These credentials are for development and controlled testing only. The
password is **not** shown on the normal login screen.

## How to log in

1. Open the app. The login screen lists accounts as cards; the nine seeded
   students appear as `Student 1` … `Student 9` with a «حساب تجريبي» badge.
2. Tap **الدخول باسم المستخدم** and enter e.g. `student5` / `111111`, or tap a
   student card and enter the same password.
3. After login the app loads that student's `Profile.schoolGrade`, so
   `student5` sees Grade 5 topics/books and `student9` sees Grade 9.

Each student has a separate profile, so stars, gems, points, exam history,
answers, achievements and level progress are stored per account.

## How the seed works

`lib/core/services/dev_account_seeder.dart` defines the nine accounts and is
called once from `main()` before the UI starts.

- **Idempotent:** it looks each username up first. Existing accounts are never
  duplicated, overwritten, deactivated, or password-reset.
- **Safe:** it only creates missing `studentN` accounts. Parent accounts and
  normal students are untouched.
- **Reported:** if a username already exists but its role, grade, active flag,
  password state, or account type differs, the seed leaves it alone and logs a
  mismatch. Fix it deliberately instead of relying on the seed to overwrite it.
- **Account type:** seeded users have `Users.accountType = 'development'`
  (schema v5). Normal accounts default to `'standard'`.
- **Passwords:** stored with the existing PBKDF2-SHA256 `PasswordHasher`
  (120,000 iterations, random salt). No plaintext password is stored or logged.

## Enabling / disabling the seed

The seed is enabled automatically in debug and profile builds. Release builds
default to **off**.

```bash
# Development / profile (default): seeded
flutter run

# Disable the convenience seed (e.g. a shared debug build)
flutter run --dart-define=SEED_DEV_ACCOUNTS=false

# Explicitly allow it in a release test build (use with care)
flutter build apk \
  --dart-define=SEED_DEV_ACCOUNTS=true \
  --dart-define=ALLOW_DEV_ACCOUNTS_IN_RELEASE=true
```

Without `ALLOW_DEV_ACCOUNTS_IN_RELEASE=true`, release builds never create the
shared accounts even if `SEED_DEV_ACCOUNTS` is left at its default.

## Recreating a missing account

Restart the app. The seeder creates only the missing `studentN` account; the
other eight and all progress stay as they are.

If a username exists with the wrong grade/role/type, the seeder reports a
mismatch and does not repair it. Correct or remove that account deliberately
through the parent/account-management flow, then restart to let the seed
recreate it. Never delete a profile that contains progress you want to keep.

## Verification

```bash
flutter test test/core/dev_account_seeder_test.dart
```

The test covers: all nine accounts, username/password login for each, correct
role and grade, case-insensitive usernames, invalid credentials, idempotent
re-runs, no password resets, mismatch reporting, per-account progress
isolation, and persistence across a database reopen.

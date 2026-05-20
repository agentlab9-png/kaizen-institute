-- ============================================================================
-- Kaizen Institute — fix broken updated_by foreign keys
-- ============================================================================
-- السبب: FK constraints على updated_by في 6 جداول تشير لجدول "users" القديم،
-- بينما المستخدمين الحقيقيين موجودين في جدول "profiles".
-- النتيجة: أي تحديث (UPDATE) من المستخدم يفشل بـ FK violation وtoast "خطأ في التحديث".
--
-- آمن 100%: تحقّقنا أن كل الجداول فيها 0 صفوف بـ updated_by ممتلئ.
-- ============================================================================

BEGIN;

-- 1) Drop broken FKs (point to users)
ALTER TABLE students          DROP CONSTRAINT IF EXISTS students_updated_by_fkey;
ALTER TABLE teachers          DROP CONSTRAINT IF EXISTS teachers_updated_by_fkey;
ALTER TABLE payments          DROP CONSTRAINT IF EXISTS payments_updated_by_fkey;
ALTER TABLE teacher_payouts   DROP CONSTRAINT IF EXISTS teacher_payouts_updated_by_fkey;
ALTER TABLE expenses          DROP CONSTRAINT IF EXISTS expenses_updated_by_fkey;
ALTER TABLE seat_reservations DROP CONSTRAINT IF EXISTS seat_reservations_updated_by_fkey;

-- 2) Recreate FKs pointing to profiles (correct)
ALTER TABLE students          ADD CONSTRAINT students_updated_by_fkey
  FOREIGN KEY (updated_by) REFERENCES profiles(id) ON DELETE SET NULL;
ALTER TABLE teachers          ADD CONSTRAINT teachers_updated_by_fkey
  FOREIGN KEY (updated_by) REFERENCES profiles(id) ON DELETE SET NULL;
ALTER TABLE payments          ADD CONSTRAINT payments_updated_by_fkey
  FOREIGN KEY (updated_by) REFERENCES profiles(id) ON DELETE SET NULL;
ALTER TABLE teacher_payouts   ADD CONSTRAINT teacher_payouts_updated_by_fkey
  FOREIGN KEY (updated_by) REFERENCES profiles(id) ON DELETE SET NULL;
ALTER TABLE expenses          ADD CONSTRAINT expenses_updated_by_fkey
  FOREIGN KEY (updated_by) REFERENCES profiles(id) ON DELETE SET NULL;
ALTER TABLE seat_reservations ADD CONSTRAINT seat_reservations_updated_by_fkey
  FOREIGN KEY (updated_by) REFERENCES profiles(id) ON DELETE SET NULL;

COMMIT;

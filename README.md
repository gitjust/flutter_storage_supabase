flutter pub add supabase_flutter

flutter pub add flutter_dotenv

flutter pub add image_picker

Make sure you have this in pubspec.yaml:

flutter:

assets:
  - assets/.env

Make assets/ folder in the project and create an .env file with:

SUPABASE_URL=

SUPABASE_ANONKEY=

Create a storage bucket named 'images', set to Public bucket, Save, then name a policy with rules: INSERT and upload, getPublicUrl

import os
import time
from huggingface_hub import login, upload_folder
from huggingface_hub.utils import HfHubHTTPError

def upload_with_retry(max_retries=3, delay=60):
    for attempt in range(max_retries):
        try:
            token = os.environ.get("HF_TOKEN")
            if not token:
                raise ValueError("HF_TOKEN environment variable is not set")
            login(token=token)
            upload_folder(
                folder_path="models",
                path_in_repo="",
                repo_id="NickLamb/OpenROAD-8B-Instruct",
                repo_type="model"
            )
            print(f"✅ Upload successful on attempt {attempt + 1}")
            return True
        except HfHubHTTPError as e:
            if e.response.status_code == 504 and attempt < max_retries - 1:
                print(f"❗ Gateway timeout on attempt {attempt + 1}. Retrying in {delay} seconds...")
                time.sleep(delay)
            else:
                print(f"❌ Error during upload: {str(e)}")
                return False
        except Exception as e:
            print(f"❌ Unexpected error during upload: {str(e)}")
            return False
    return False

if __name__ == "__main__":
    if not upload_with_retry():
        print("❌ Upload failed after multiple attempts")
        exit(1)

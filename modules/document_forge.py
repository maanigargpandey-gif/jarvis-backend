async def create_document(doc_type: str, details: dict):
    # 1. Resume / Cover Letter
    if doc_type == "resume" or doc_type == "cover_letter":
        return {
            "status": "success",
            "message": f"Professional {doc_type} formatted and ready.",
            "technical_logs": [
                "Analyzing user profile and target job role...",
                "Applying ATS-friendly template...",
                "Exporting to PDF format."
            ],
            "mock_download_link": f"https://jarvis-cloud.storage.com/docs/{doc_type}_mock.pdf"
        }
    
    # 2. CSC / Government Form Auto-fill
    elif doc_type == "govt_form":
        form_name = details.get("form_name", "General Application")
        return {
            "status": "success",
            "message": f"Form '{form_name}' filled automatically using AI extraction.",
            "technical_logs": [
                "Extracting details from provided voice/text command...",
                "Mapping data to official PDF fields...",
                "Bypassing captcha (simulated)...",
                "Form ready for submission."
            ],
            "mock_download_link": f"https://jarvis-cloud.storage.com/docs/filled_{form_name}_mock.pdf"
        }

    return {"status": "error", "message": "Unsupported document format."}
  

let pageTitle = '';
let pageUrl = '';

// Get current tab info when popup opens
chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
  const tab = tabs[0];
  pageTitle = tab.title || 'Untitled';
  pageUrl = tab.url || '';

  document.getElementById('pageTitle').textContent = pageTitle;
  document.getElementById('pageUrl').textContent = pageUrl;
});

// Handle save button click
document.getElementById('saveBtn').addEventListener('click', async () => {
  const btn = document.getElementById('saveBtn');
  const status = document.getElementById('status');

  btn.disabled = true;
  btn.textContent = 'Saving...';
  status.className = 'status';
  status.style.display = 'none';

  try {
    // Send message to native messaging host
    const response = await chrome.runtime.sendNativeMessage(
      'com.applenotes.chrome',
      {
        action: 'createNote',
        title: pageTitle,
        url: pageUrl
      }
    );

    if (response && response.success) {
      status.className = 'status success';
      status.textContent = 'Saved to Apple Notes!';
      status.style.display = 'block';
      btn.textContent = 'Saved!';
    } else {
      throw new Error(response?.error || 'Unknown error');
    }
  } catch (error) {
    status.className = 'status error';
    status.textContent = 'Error: ' + error.message;
    status.style.display = 'block';
    btn.textContent = 'Save to Notes';
    btn.disabled = false;
  }
});

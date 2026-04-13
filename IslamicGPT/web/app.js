const chat = document.getElementById("chat");
const form = document.getElementById("chat-form");
const textarea = document.getElementById("question");
const sendBtn = document.getElementById("send");
const template = document.getElementById("message-template");

function addMessage(role, text, className = "") {
  const node = template.content.firstElementChild.cloneNode(true);
  node.classList.add(role);
  if (className) {
    node.classList.add(className);
  }

  node.querySelector(".role").textContent = role === "user" ? "You" : "IslamicGPT";
  node.querySelector(".content").textContent = text;
  chat.appendChild(node);
  chat.scrollTop = chat.scrollHeight;
}

addMessage(
  "assistant",
  "Assalamu 'alaykum. Ask a question and I will respond only from the local Islamic datasets with citations."
);

form.addEventListener("submit", async (e) => {
  e.preventDefault();
  const question = textarea.value.trim();
  if (!question) {
    return;
  }

  addMessage("user", question);
  textarea.value = "";
  textarea.focus();
  sendBtn.disabled = true;

  try {
    const res = await fetch("/ask", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ question }),
    });

    if (!res.ok) {
      addMessage("assistant", "Allahu a'lam", "rejected");
      return;
    }

    const data = await res.json();
    addMessage("assistant", data.answer, data.rejected ? "rejected" : "");
  } catch {
    addMessage("assistant", "Allahu a'lam", "rejected");
  } finally {
    sendBtn.disabled = false;
  }
});

![Enchanted banner](./assets/banner.png)
![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![Release](https://img.shields.io/github/v/release/augustdev/enchanted?style=for-the-badge)
![Stars](https://img.shields.io/github/stars/augustdev/enchanted.svg?style=for-the-badge)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
![iOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=ios&logoColor=white)
[<img src="https://img.shields.io/badge/App_Store-0D96F6?style=for-the-badge&logo=app-store&logoColor=white">](https://apps.apple.com/gb/app/enchanted-llm/id6474268307)
[<img src="https://img.shields.io/badge/App_Store-0D96F6?style=for-the-badge&logo=app-store&logoColor=white">](https://twitter.com/amgauge)
[<img src="https://img.shields.io/twitter/url?url=https%3A%2F%2Ftwitter.com%2Famgauge&style=for-the-badge">](https://twitter.com/amgauge)

# Enchanted

Enchanted is open source, [Ollama](https://github.com/jmorganca/ollama) compatible, elegant macOS/iOS/iPad app for working with privately hosted models such as Llama 2, Mistral, Vicuna, Starling and more. It's essentially ChatGPT app UI that connects to your private models. The goal of Enchanted is to deliver a product allowing unfiltered, secure, private and multimodal experience across all of your devices in iOS ecosystem (macOS, iOS, Watch, Vision Pro).

If you like the project, consider leaving a ⭐️ and following on [𝕏](https://twitter.com/amgauge).

## App Store

[<img src="https://i.ibb.co/7WXt3qZ/download.png">](https://apps.apple.com/gb/app/enchanted-llm/id6474268307)

Note: You will need to run your own Ollama server to use the app. Read instructions below.

## Demo

[<img src="./assets/promo.png">](https://www.youtube.com/watch?v=zW3roZ_vM5Q)

## Features

- Supports latest Ollama Chat API
- Conversation history included in the API calls
- Dark/Light mode
- Conversation history is stored on your device
- Markdown support (nicely displays tables/lists/code blocks)
- Voice prompts
- Image attachments for prompts
- Specify system prompt used for every conversations
- Edit message content or submit message with different model
- Delete single conversation / delete all conversations
- macOS Spotlight panel <kbd>Ctrl</kbd>+<kbd>⌘</kbd>+<kbd>K</kbd>

### Coming soon

- RAG (talk with your files)
- Download new models using UI
- Conversation syncing between devices
- Multiple conversation for macOS

## Usage instructions

Enchanted requires Ollama v0.1.14 or later.

### Case 1. You run Ollama server with public access

1. Download Enchanted app from the App Store.
2. In App Setings specify your server endpoint.

You're done! Make a prompt.

### Case 2. You run Ollama on your computer

[Video instructions here](https://www.youtube.com/watch?v=SFeVCiLOABM)

1. Start Ollama server and download models for usage.
2. Install ngrok forward your Ollama server to make it accessible publicly

   ```shell
   ngrok http 11434
   ```

3. Copy "Forwarding" URL that will look something like `https://b377-82-132-216-51.ngrok-free.app`. Your Ollama server API is now accessible through this temporary URL.
4. Download Enchanted app from the App Store.
5. In App Setings specify your server endpoint.

   You're done! Make a prompt.

# Contact

For any questions please do not hesitate to contact me at augustinas@subj.org

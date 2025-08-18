# send_sms

This project was born from a personal need to learn Flutter through a simple project, and to be able to send SMS via a local API. It serves as a playground to discover the Flutter ecosystem and experiment with custom SMS sending.

**send_sms** is a Flutter application for sending SMS messages via any SMS API. The app provides a simple interface to input sender and recipient numbers, compose a message, and send it directly through a configurable API.

## Features

- Send SMS messages using any compatible SMS API (configurable).
- Input validation for sender and recipient numbers (6 digits).
- Character counter for SMS messages (max 160 characters).
- Cross-platform: Android, iOS, Linux, macOS, Windows, and Web.

## Screenshots

*(Add screenshots here)*

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- An API key and endpoint for your chosen SMS provider

### Installation

1. **Clone the repository:**

	```sh
	git clone https://github.com/Supervinh/send_sms.git
	cd send_sms
	```

2. **Install dependencies:**

	```sh
	flutter pub get
	```

3. **Configure environment variables:**

	- Create a `.env` file at the root of the project.
	- Add your API key and endpoint, for example:

	  ```env
	  SMS_API_KEY=your_api_key_here
	  SMS_API_URL=https://your-sms-api-endpoint.com/send
	  ```

	*(Check the documentation of your SMS provider for the required variables and format.)*

4. **Run the app:**

	```sh
	flutter run
	```

## Usage

- Enter a 6-digit sender number (optional).
- Enter a 6-digit recipient number (required).
- Type your message (up to 160 characters).
- Press "Send" to send the SMS via your configured API.

> **Note:**
> The input validation for phone numbers (e.g., 6 digits) and the maximum SMS length (e.g., 160 characters) are currently set as examples. You should adapt these constraints in the code to match the requirements and limitations of your own SMS provider and use case.

## Project Structure

- `lib/main.dart`: Main application code.
- `test/widget_test.dart`: Basic widget test.
- Platform-specific folders: `android/`, `ios/`, `linux/`, `macos/`, `web/`, `windows/`.

## Dependencies

- `flutter`
- `http`
- `flutter_dotenv`
- `provider`
- `cupertino_icons`
- `english_words`

See `pubspec.yaml` for the full list.

## License

This project is licensed under the terms of the LICENSE file.
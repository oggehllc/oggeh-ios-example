# OGGEH iOS Example

Example iOS code for making OGGEH API Requests

> You need a Developer Account to obtain your App API Keys, if you don't have an account, [request](https://account.oggeh.com/request) one now.

## Requirements

* Xcode 8

## IMPORTANT

You should not use Sandbox headers in production mode to avoid blocking your App along with your Developer Account for violating our terms and conditions!
If you're planning to use this example, remove the `SandBox` header from JavaScript (_assets/js/main.js @line 70_)

### Usage

1. Open `iOSClient.xcodeproj` in Xcode.
2. Locate `OGGEH.m` and review `apiCall` method.
3. Straight forward test will be using `SandBox` request.
4. For production mode, comment out SandBox request code (_@line 37, 39, and 40_), along with setting SandBox custom header @line 65, then uncomment everything between the lines 43 and 54.

## API Documentation

See [API Reference](http://docs.oggeh.com/#reference-section) for additional details on available values for _select_ attribute on each API Method.

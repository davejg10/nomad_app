# Nomad app

This repository stores the Dart code for the Nomad application. 

### State management tool:

1)  [Riverpod](https://riverpod.dev/docs/introduction/why_riverpod) for state management. Although Riverpod comes with a code generator that helps ease provider development, we are manually creating the providers/notifiers without any annotations to avoid having to use code generation. 

### Project structure:


- Our project is structured with a screen first approach. There is a directory for each of the screens and then within this there are sub-directories `providers` & `widgets` which compartmentalise logic for that specific screen. Then, at the root, there is a final xx_screen.dart which acts as the skeleton of the screen and pulls in each of these comparmentaislied bits.
- Providers that are shared across many screens go in [./lib/providers/](./lib/providers/) 
- Widgets that are shared across many screens go in [./lib/widgets/](./lib/widgets/)

### Running the app

#### Simulator

- If running the app on a simulator within Android studio then the backendURI in [./lib/providers/backend_repository_provider.dart](./lib/providers/backend_repository_provider.dart), should be set to `'http://10.0.2.2:8080'` as this is local host
- If running on a real device then the backendURI should be `'http://<ipadress>:8080'` where `<ipaddress>` is your IPv4 address found by running `ipconfig`






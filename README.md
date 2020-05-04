# My Jeedom Flutter App

In full discovery of Flutter, I made this application to implement the main concepts. Passionate about home automation, I made an application to connect to my Jeedom server. 

## Architecture used
- **Bloc Pattern**: I simply followed the fashionable pattern to understand why it is so popular.
- **Atomic Design**: here I propose my interpretation of this design pattern on the architecture of UI components.
    - *The atoms*: small non-divisible widgets, non-functional alone,
    - *Molecules*: set of atoms, non-functional alone,
    - *Organisms*: set of molecules/atoms. Organisms are alive and can therefore interact with the blocks.
    - *The pages*: orchestration of the complete scene.
    - *The screens*: container of the pages which allows to isolate the implementation of the blocks and the links between them.
- **Firebase Authentication**: the all-in-one solution to secure the application. It also allows to easily integrate other providers (Facebook, Twitter ...).
- **Firebase Firestore**: to store information such as the access url to the server and retrieve it in case of a change of device.
- **Api Jeedom Server** : classic management of access to an api.
- **Advanced animation** : to bring fun. 

## Topics not covered / to go further
- Splashscreen implementation: seems mandatory due to the horrible default white screen when launching the application.
- Testing: I've implemented some unit tests on the blocks but more can be produced. I didn't implement interface tests.
- Data persistence : for Jeedom server data maybe.
- Accessibility
- Internationalization

## Resources :

- [Didier Boelens Bloc pattern vision](https://www.didierboelens.com/fr/2018/12/reactive-programming-streams-bloc-cas-practiques-dutilisation/)
- [Nice talk about advanced animation](https://www.youtube.com/watch?v=FCyoHclCqc8)

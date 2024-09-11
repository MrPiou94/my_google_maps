# my_google_maps

**Intégration de Google Maps dans votre Application Cross-Plateforme (Web, Android, iOS)**
Introduction
Dans ce tutoriel, je vais vous guider point par point pour activer et connecter Google Maps avec votre application cross-plateforme. Nous aborderons l'activation des API sur votre Google Cloud Console, la sécurisation de vos clés API pour éviter toute usurpation, et un petit bonus avec l'API Geolocator pour la géolocalisation des adresses.

⚠️ Important : Ne nommez pas votre projet google_maps pour éviter les conflits avec le package existant sur pub.dev lors du pub get.

**Étape 1 : Créer votre application sur la Google Cloud Console**
*https://console.cloud.google.com/*

**Étape 2 : Activer les API Google Maps pour chaque plateforme (Web, Android, iOS).**
*https://console.cloud.google.com/apis/dashboard?project=aylicrea-409808*
Maps JavaScript API
Maps SDK for Android
Maps SDK for iOS
Geocoding API

**Étape 3 : Activer et sécuriser les clés API**
*https://console.cloud.google.com/apis/credentials*
Il est primordial de protéger vos clés API pour éviter toute usurpation. Voici quelques conseils pour protéger vos clés selon les plateformes :

***Web*** : Limitez la clé à votre domaine web et restreignez son utilisation.
https://*.exemple.com	
https://exemple.com	

***Android*** : Limitez l'utilisation de la clé API aux SHA1 de votre application.
*https://play.google.com/console/*
Google Play Console => Certificat de la clé de signature d'application
com.exemple.mygooglemaps
F6:A8:7C:95:9F:B0:37:79:A4:F0:7F:9B:86:9A:66:3B:7A:B4:69:D9	

***iOS*** : Restreignez la clé aux identifiants de l'application (Bundle Identifier).
com.exemple.mygooglemaps

***localhost*** : Mettez à jour le port à chaque lancement de votre console de développement.
http://localhost:57714

***GEOCODING*** : IP de votre serveur.


**Étape 4 : Ajouter les packages dans le fichier pubspec.yaml**
*https://pub.dev/packages/google_maps_flutter*
*https://pub.dev/packages/google_maps_flutter_web/install*
*https://pub.dev/packages/geolocator*

  google_maps_flutter: ^2.9.0
  google_maps_flutter_web: ^0.5.10
  geolocator: ^13.0.1

**Étape 5 : Configurer les permissions**

AndroidManifest.xml
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>

info.plist
        <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
        <string>Need Location permission for maps.</string>
        <key>NSLocationAlwaysUsageDescription</key>
        <string>Need Location permission for maps.</string>
        <key>NSLocationWhenInUseUsageDescription</key>
        <string>Need Location permission for maps.</string>










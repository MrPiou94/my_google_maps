# my_google_maps

# **Google Maps Cross-Platform avec Flutter (Web, Android, iOS)**   
Introduction   
Dans ce tutoriel, je vais vous guider point par point pour activer et connecter Google Maps avec votre application cross-plateforme. Nous aborderons l'activation des API sur votre Google Cloud Console, la sécurisation de vos clés API pour éviter toute usurpation, et en bonus la recherche d'adresse avec l'API Geolocator pour la géolocalisation.   

⚠️ Important : Ne nommez pas votre projet google_maps pour éviter les conflits avec le package existant sur pub.dev lors du pub get.  

Video   
https://youtu.be/nAotNNj9G2Q   

J'ai inclus une version de démonstration pour vous aider à visualiser le résultat attendu.   
*https://asyoulikekit.com/map/*

# **Étape 1 : Créer votre application sur la Google Cloud Console**

*https://console.cloud.google.com/*

# **Étape 2 : Activer les API Google Maps pour chaque plateforme**

*https://console.cloud.google.com/apis/dashboard*

Maps JavaScript API  
Maps SDK for Android  
Maps SDK for iOS  
Geocoding API  

# **Étape 3 : Sécuriser les clés API**  
Il est primordial de protéger vos clés API en limitant leur utilisation pour éviter toute usurpation. Renommez-les pour les distinguer facilement :  
*https://console.cloud.google.com/apis/credentials*   

+ **Web** : Limitez à votre domaine.

https://exemple.com	  
https://*.exemple.com	  

+ **Android** : Limitez au certificat de la clé de signature d'application SHA1.  
Vous le trouverez sur votre Google Play Console.  
*https://play.google.com/console/*  

com.exemple.mygooglemaps  
F6:A8:7C:95:9F:B0:37:79:A4:F0:7F:9B:86:9A:66:3B:7A:B4:69:D9	  

+ **iOS** : Restreignez la clé aux identifiants de l'application (Bundle Identifier).  

com.exemple.mygooglemaps  

+ **localhost** : Mettez à jour le port à chaque lancement de votre console de développement.  

http://localhost:57714   

+ **GEOCODING** : IP de votre serveur.   

# **Étape 4 : Ajouter les packages dans le fichier pubspec.yaml**  
*https://pub.dev/packages/google_maps_flutter*   
*https://pub.dev/packages/google_maps_flutter_web/install*   
*https://pub.dev/packages/geolocator*   

  google_maps_flutter: ^2.9.0  
  google_maps_flutter_web: ^0.5.10  
  geolocator: ^13.0.1  

# **Étape 5 : Configurer les permissions**  


AndroidManifest.xml  
```xml
    <uses-permission android:name="android.permission.INTERNET"/>  
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>  
```

info.plist  
```xml
        <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>  
        <string>Need Location permission for maps.</string>  
        <key>NSLocationAlwaysUsageDescription</key>  
        <string>Need Location permission for maps.</string>  
        <key>NSLocationWhenInUseUsageDescription</key>  
        <string>Need Location permission for maps.</string>  
```


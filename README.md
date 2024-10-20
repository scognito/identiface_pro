# IdentiFace

A minimalistic, responsive, multilanguage and powerful face recognition app for Android, iOS,
Desktop,
and Web, using [Compreface](https://github.com/exadel-inc/CompreFace) as backend.

Tutorial for setting up Compreface can be
found [here](https://scognito.wordpress.com/2024/09/02/how-to-configure-an-easy-free-and-open-source-face-recognition-service/).

Detail description of the app can be
found [here](https://scognito.wordpress.com/2024/09/02/how-to-configure-an-easy-free-and-open-source-face-recognition-service/).

The app comes with 2 themes: a default (cyberpunk style) and Material like.

The app can be used as a face recognition program that executes custom API calls once the face is
recognized, allowing integration with many things like home automation, IoT devices, etc.

One example of API could be opening remote doors, send notifications etc.

It is created as a standalone app,it doesn't store any user information except the avatar image
of the user (optional). No information is stored on the device.

## Get it

<a href="https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=6736407084" target="_blank">
    <img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" alt="Download on the App Store (iOS)" height="50">
</a>
<br>
<a href="https://play.google.com/store/apps/details?id=it.scognito.face_detector" target="_blank">
    <img src="https://upload.wikimedia.org/wikipedia/commons/7/78/Google_Play_Store_badge_EN.svg" alt="Get it on Google Play" height="50">
</a>
<br>
<a href="https://apps.apple.com/nl/app/identiface-pro/id6736407084?l=en-GB" target="_blank">
    <img src="https://tools.applemediaservices.com/api/badges/download-on-the-mac-app-store/black/en-us" alt="Download on the Mac App Store" height="50">
</a>
<br>
<!-- https://apps.microsoft.com/badge?hl=en-US&gl=US -->
<a href="https://apps.microsoft.com/detail/9MZ7HH1NJBGM?mode=direct">
    <img src="https://get.microsoft.com/images/it%20dark.svg" width="200"/>
</a>


## For devs

### Adding new backend service

The app is created with compreface as backend. You can use whatever backend you want, just edit
[api service](./lib/services/api_service.dart) accordingly.

### Adding new themes

Adding new theme is also easy: themes are located inside
the [theme directory](./lib/screens/recognize/theme/), you can add your theme in there too.

## Screenshots

<table>
    <tr>
        <td><a href="screenshots/desktop-material-title.jpeg" target="_blank"><img alt="Title Screen" src="screenshots/desktop-material-title.jpeg" width="200"/></a></td>
        <td><a href="screenshots/desktop-default-settings.jpeg" target="_blank"><img alt="Settings on Desktop" src="screenshots/desktop-default-settings.jpeg" width="200"/></a></td>
    </tr>
    <tr>
        <td><a href="screenshots/ipad Large.jpeg" target="_blank"><img alt="Recognize screen on Desktop" src="screenshots/ipad Large.jpeg" width="200"/></a></td>
        <td><a href="screenshots/desktop-default-recognize-match-01.jpeg" target="_blank"><img alt="Face recognized on Desktop" src="screenshots/desktop-default-recognize-match-01.jpeg" width="200"/></a></td>
    </tr>
    <tr>
        <td><a href="screenshots/desktop-default-add-user-03.jpeg" target="_blank"><img alt="Edit user on Desktop" src="screenshots/desktop-default-add-user-03.jpeg" width="200"/></a></td>
        <td><a href="screenshots/desktop-default-change-camera.jpeg" target="_blank"><img alt="Camera settings on Desktop" src="screenshots/desktop-default-change-camera.jpeg" width="200"/></a></td>
    </tr>
    <tr>
        <td><a href="screenshots/mobile-default-landscape-recognize.jpeg" target="_blank"><img alt="Recognize screen on Mobile, landscape" src="screenshots/mobile-default-landscape-recognize.jpeg" width="200"/></a></td>
        <td><a href="screenshots/mobile-material-landscape-recognize.jpeg" target="_blank"><img alt="Recognize screen on Mobile, landscape, Material theme" src="screenshots/mobile-material-landscape-recognize.jpeg" width="200"/></a></td>
    </tr>
    <tr>
        <td><a href="screenshots/piero2.jpg" target="_blank"><img alt="Recognize screen on Mobile, portrait, Material theme" src="screenshots/piero2.jpg" width="200" height="auto"/></a></td>
        <td><a href="screenshots/mobile-default-portrait-recognize-02.jpeg" target="_blank"><img alt="Recognize screen on Mobile, portrait" src="screenshots/mobile-default-portrait-recognize-02.jpeg" width="200" height="auto" /></a></td> 
    </tr>
</table>

## Test API

Some sample API calls:

`curl -X GET "http://compreface-ip:8000/api/v1/recognition/subjects" \
-H "Content-Type: application/json" \
-H "x-api-key: your-api-key-here"`

`curl -X POST 'http://compreface-ip:8000/api/v1/recognition/recognize' \
-H 'x-api-key: your-api-key-here' \
-H 'Content-Type: multipart/form-data' \
-F 'userId=Piero' \
-F 'file=@/Users/scognito/Desktop/face.jpg'`

Full API
documentation [here]( https://github.com/exadel-inc/CompreFace/blob/master/docs/Rest-API-description.md).

# Run web with same configuration

--web-port 8000

# Linux support

Linux support is experimental, as the actual camera plugin is in early stage.

Note: You need to install libopencv-dev

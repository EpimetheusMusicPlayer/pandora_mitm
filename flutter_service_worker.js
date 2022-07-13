'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "85971e0cf04ef6c8cbd21f8658dadf8a",
"index.html": "ba89920f300c777d0503ff550be05915",
"/": "ba89920f300c777d0503ff550be05915",
"main.dart.js": "34d5abb33f1252cd1eff34708cec4fec",
"flutter.js": "eb2682e33f25cd8f1fc59011497c35f8",
"favicon.png": "9ac1366f1b32f298cbd2ac938fa36f24",
"icons/icon_circular16px.png": "0b5d5f806980038a18616c3a28d73995",
"icons/icon_circular32px.png": "ad3db3cba21481f7d04cc6955b0de032",
"icons/icon_circular1024px.png": "a98e104ff628eb1a50ab54ed5fcea2ff",
"icons/icon_circular512px.png": "46e4ce077002249f1702ffa7b7e68c5c",
"icons/icon_circular256px.png": "6d7fcf04ac6219882cd5dde76dfc2646",
"icons/icon_circular128px.png": "adcefe9e15c555367ba664a87c89a92c",
"icons/icon_circular64px.png": "d9bf40abfeecb4e0fbe1779428b5a544",
"icons/icon_circular192px.png": "32706685ee584ae413e86b1295e8062c",
"manifest.json": "cc7926fefc2c60b3dea965f1f0e6f7db",
"assets/AssetManifest.json": "d9f5d03298487aae4272f82fcfe7cb03",
"assets/NOTICES": "7a52854b93ad1df9c76d89a2491e3f4e",
"assets/FontManifest.json": "d3a20431a906d25b53abc0c5aa1463bb",
"assets/packages/pandora_mitm_gui_core/fonts/JetBrainsMono/JetBrainsMono-Thin.ttf": "bfe2ec0a0644c54aab4ef5c62270e9d8",
"assets/packages/pandora_mitm_gui_core/fonts/JetBrainsMono/JetBrainsMono-Bold.ttf": "de2ce9b374d438453112214b81e41849",
"assets/packages/pandora_mitm_gui_core/fonts/JetBrainsMono/JetBrainsMono-Italic.ttf": "342fa9d499e506144959ab12673ae0c4",
"assets/packages/pandora_mitm_gui_core/fonts/JetBrainsMono/JetBrainsMono-LightItalic.ttf": "31ea3e84275f092f9a2790a2d07eaf36",
"assets/packages/pandora_mitm_gui_core/fonts/JetBrainsMono/JetBrainsMono-Regular.ttf": "a7151c5349c1aa20beefb3c5430c3a79",
"assets/packages/pandora_mitm_gui_core/fonts/JetBrainsMono/JetBrainsMono-ExtraLightItalic.ttf": "1673c5d8387eac872c5e15737a2e49b3",
"assets/packages/pandora_mitm_gui_core/fonts/JetBrainsMono/JetBrainsMono-SemiBoldItalic.ttf": "eff07c40d692cec6eef64a6d7c342709",
"assets/packages/pandora_mitm_gui_core/fonts/JetBrainsMono/JetBrainsMono-Light.ttf": "5f0dea0a306e3416b10c4f96ba8e854c",
"assets/packages/pandora_mitm_gui_core/fonts/JetBrainsMono/JetBrainsMono-MediumItalic.ttf": "7c0fde06b7cfe8baa7d85fae639b60ea",
"assets/packages/pandora_mitm_gui_core/fonts/JetBrainsMono/JetBrainsMono-ExtraBold.ttf": "fb177aca3a88192fea54d61ccdfccb90",
"assets/packages/pandora_mitm_gui_core/fonts/JetBrainsMono/JetBrainsMono-SemiBold.ttf": "1f31a0afcc72c1472ce7801fe86b5d53",
"assets/packages/pandora_mitm_gui_core/fonts/JetBrainsMono/JetBrainsMono-ExtraBoldItalic.ttf": "ef33cdb6734a9a9a40983fcb553e7460",
"assets/packages/pandora_mitm_gui_core/fonts/JetBrainsMono/JetBrainsMono-ThinItalic.ttf": "cf05ccbc3ede81bec5398fb617caef46",
"assets/packages/pandora_mitm_gui_core/fonts/JetBrainsMono/JetBrainsMono-ExtraLight.ttf": "8fd44009bd92b12998cfe8cd28cb382a",
"assets/packages/pandora_mitm_gui_core/fonts/JetBrainsMono/JetBrainsMono-Medium.ttf": "2ab3c46a017cadf52f504054eee882ad",
"assets/packages/pandora_mitm_gui_core/fonts/JetBrainsMono/JetBrainsMono-BoldItalic.ttf": "b91689d7bbb1eec1e1c839d7ef9a0340",
"assets/packages/pandora_mitm_gui_core/assets/epimetheus_icon.png": "6e776f0412044c4af77df710f9a22ba0",
"assets/shaders/ink_sparkle.frag": "73a6d23e8f61078e7f4a8ee194a0d464",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"canvaskit/canvaskit.js": "c2b4e5f3d7a3d82aed024e7249a78487",
"canvaskit/profiling/canvaskit.js": "ae2949af4efc61d28a4a80fffa1db900",
"canvaskit/profiling/canvaskit.wasm": "95e736ab31147d1b2c7b25f11d4c32cd",
"canvaskit/canvaskit.wasm": "4b83d89d9fecbea8ca46f2f760c5a9ba"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

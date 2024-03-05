'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "cd49e6141063f9e7c3d4099b0430bbc1",
"assets/AssetManifest.bin.json": "9be0fc5c008b85f3c2a36316882d1dfa",
"assets/AssetManifest.json": "1009b69b152368c3bdc92255b19397d4",
"assets/assets/EAC/Picture1.jpg": "5aef0a830d08364db715b0da71de73ca",
"assets/assets/EAC/Picture10.jpg": "80b314c6a9bbdc37f5e009198ee324ca",
"assets/assets/EAC/Picture11.jpg": "435c062f1d5826814799c16f8bc964ac",
"assets/assets/EAC/Picture2.jpg": "8a126ec47279de4993e966aedc9da5eb",
"assets/assets/EAC/Picture3.jpg": "418a29dff227cb2b7c4f68048a6ae936",
"assets/assets/EAC/Picture4.jpg": "66b09ad3ffa9e188b0346873f1181a92",
"assets/assets/EAC/Picture5.jpg": "b4c34dca6c5961d997a39c89e5e33403",
"assets/assets/EAC/Picture6.png": "d707b75d2ddcca6d9835b8681084e8b2",
"assets/assets/EAC/Picture7.jpg": "5b11a58ba955ed495f67a1a423a120ad",
"assets/assets/EAC/Picture8.jpg": "fa1007c0fdc7ceab220c01888edbd57b",
"assets/assets/EAC/Picture9.jpg": "c275a0a48689abaf7d3c22e3b799a277",
"assets/assets/icon/canteen.png": "b838b146c02e87974d4288c5e63d527c",
"assets/assets/icon/church.png": "5be39407eed92dd84ea827133e4ab33a",
"assets/assets/icon/eac.png": "4e471cce38312ab4d7cc06234b20a0f1",
"assets/assets/icon/engr-abm.png": "b0b01ac99566f52864e739c74938fb82",
"assets/assets/icon/lcc.png": "7cda516d699ba14cf16d5e54e3609a97",
"assets/assets/icon/lib.png": "ff68b943d23979c81237390655356065",
"assets/assets/icon/nac.png": "6bfe7916959cb6755da9d3d4b3974b0a",
"assets/assets/icon/rh.png": "d2ed8eea58d68f0c4ec7efa5b36ed496",
"assets/assets/icon/sac.png": "c4e2100c53c46ee43b892d8ccda84a03",
"assets/assets/icon/wac.png": "89214dcfc78eb990b3f1276738c16e4d",
"assets/assets/icon/you.png": "cfa50b056cc6cf9dba1302ff3dd41acd",
"assets/assets/NAC/Picture1.jpg": "43b61388634915d9555993ed437fcd25",
"assets/assets/NAC/Picture10.jpg": "ea1903d721c64a2e61f793ba5b4e7d6b",
"assets/assets/NAC/Picture11.jpg": "b0f60a48e073eff81f4d8867c71a7186",
"assets/assets/NAC/Picture12.jpg": "7f9cf274d964f66a89e49e7962187e03",
"assets/assets/NAC/Picture13.jpg": "37a0f95769987301147b40eca9e6b9b5",
"assets/assets/NAC/Picture2.jpg": "4bcdaa4d4c018e9ecffa274cd6bd1e44",
"assets/assets/NAC/Picture3.jpg": "184dfbe6ec3083eea1beea0ff45eb293",
"assets/assets/NAC/Picture4.jpg": "771c9e6f66ba262cdb388d97c03c5931",
"assets/assets/NAC/Picture5.jpg": "bd51e1bd4c0f911a866e6856d307dfc1",
"assets/assets/NAC/Picture6.jpg": "4f4c86652baebf2d41f5aeeb5b86ba2f",
"assets/assets/NAC/Picture7.jpg": "a3ff297c17cf798acdc0916ab65b6f43",
"assets/assets/NAC/Picture8.jpg": "aef401c37f052329f615fe09f663bf26",
"assets/assets/NAC/Picture9.jpg": "2aebc1adf4df2bf2e6cbc8f640a4fa79",
"assets/assets/o3d/campus-map.gltf": "db9df822937a00ce16dc99577598a534",
"assets/assets/SAC/Picture1.jpg": "898112e9863c2eff5f51815f6bbd79ab",
"assets/assets/SAC/Picture10.jpg": "f29e082bf8155bda992e5d717c20d5c9",
"assets/assets/SAC/Picture11.jpg": "8e0d31a0a3027c9e1b917809a03c64e3",
"assets/assets/SAC/Picture12.jpg": "f461e84da9066f6596b9e20d69e10f9a",
"assets/assets/SAC/Picture13.jpg": "a8b7aab7c08aa77450e49d7add7e1af5",
"assets/assets/SAC/Picture14.jpg": "878aef6f020c09d7e0cba956781c2253",
"assets/assets/SAC/Picture15.jpg": "e482aad3374162111699019805cc99bb",
"assets/assets/SAC/Picture16.jpg": "b2a576ea26559f327f91da5ea2662e9e",
"assets/assets/SAC/Picture17.jpg": "a1b446c1002c3f8e8d32ed0044b093a7",
"assets/assets/SAC/Picture18.jpg": "30ad8b28ab90b5a89197b970ad30c9ff",
"assets/assets/SAC/Picture19.jpg": "98635a9de81db18131e20a06074179c7",
"assets/assets/SAC/Picture2.jpg": "6ff9e9f0eb399430ffb693a60e6b0270",
"assets/assets/SAC/Picture20.jpg": "89fa0d4022d02be808f9971e3fca49d0",
"assets/assets/SAC/Picture21.jpg": "6d4e9147ee8f7e0d23dbc292163bbb58",
"assets/assets/SAC/Picture22.jpg": "c5a2c88a5b6b5dcc6720b74d8fc8107a",
"assets/assets/SAC/Picture23.jpg": "8720d3638e057b922cb1c65c83da9190",
"assets/assets/SAC/Picture24.jpg": "42fdbf009708ea7729eaef213def1f64",
"assets/assets/SAC/Picture25.jpg": "057a5926366c50fbce9443886ad69d85",
"assets/assets/SAC/Picture26.jpg": "7c2bba8562d9be825b5dcd185fd21fc0",
"assets/assets/SAC/Picture27.jpg": "b574492470f4cb26194f03d7715c7847",
"assets/assets/SAC/Picture28.jpg": "79a8d939b7d245bf632c703fb913c223",
"assets/assets/SAC/Picture29.jpg": "86a480cb0f2a280410928190de42da80",
"assets/assets/SAC/Picture3.jpg": "91a43f06dd50584f69ff51fab512be06",
"assets/assets/SAC/Picture30.jpg": "294c9b2da3d871aaff95344251fbd7ec",
"assets/assets/SAC/Picture31.jpg": "9d6760aae6319e039bc8d42b14944972",
"assets/assets/SAC/Picture32.jpg": "54afa5da303171e22bdc3f88e2111bde",
"assets/assets/SAC/Picture4.jpg": "20cf5d03a15d423dfb6afb626602d934",
"assets/assets/SAC/Picture5.jpg": "cc42a36b5e6cf346d26a02d139f05884",
"assets/assets/SAC/Picture6.jpg": "4322f7f45601f0b3ce6c6b42d175ecb3",
"assets/assets/SAC/Picture7.jpg": "b6d1d14fd17eda7d1c4167f879659653",
"assets/assets/SAC/Picture8.jpg": "4f10a99b73776716db1418e17e95d436",
"assets/assets/SAC/Picture9.jpg": "fbe55441973d59d0cd9a3dc1cc576fa1",
"assets/assets/WAC/Picture1.jpg": "483ad578661a1a3ed27aab3fbdb7a1fa",
"assets/assets/WAC/Picture10.jpg": "9f165eaa7f7b7648451983b4557fb590",
"assets/assets/WAC/Picture11.jpg": "34cfb8a234a2ceabd3b0e893fa7d1ed6",
"assets/assets/WAC/Picture12.jpg": "ab69f6ad8d4f6fefd14f5c4d9381b3cb",
"assets/assets/WAC/Picture13.jpg": "ff8c722c71f0a84863eca52d361fdb50",
"assets/assets/WAC/Picture14.jpg": "4eb1a9bc73b725d6c28d8728ab356237",
"assets/assets/WAC/Picture15.jpg": "9302123c048eed3869d69efe7220ce1c",
"assets/assets/WAC/Picture16.jpg": "51169840155225951c1a60044abc721b",
"assets/assets/WAC/Picture17.jpg": "9b2039b9cce81cd3bcc67cb59d79e2ce",
"assets/assets/WAC/Picture18.jpg": "9038fc52d4129b61481a3d07ab340714",
"assets/assets/WAC/Picture19.jpg": "85f9ac78058b16db1522ed7defed190d",
"assets/assets/WAC/Picture2.jpg": "671713d0159279bc9b2945205e1cd5b4",
"assets/assets/WAC/Picture20.jpg": "f3f96c7b58f990db44f2ccca173e30e9",
"assets/assets/WAC/Picture21.jpg": "830ac085cd464c8bf9f19154da58dfa4",
"assets/assets/WAC/Picture22.jpg": "f0f2b1469216d61e10505d392671219e",
"assets/assets/WAC/Picture23.jpg": "256d97c78c56a7ba908b864cd8476225",
"assets/assets/WAC/Picture24.jpg": "a939e49a79c31973a9610bfa28114d31",
"assets/assets/WAC/Picture3.jpg": "51a34b57ace0bc966a63391a8897f9c0",
"assets/assets/WAC/Picture4.jpg": "cd8f7e0e795900eeebbb2e44d3c881b3",
"assets/assets/WAC/Picture5.jpg": "3e2c498047ebfca6812fc02f260f432e",
"assets/assets/WAC/Picture6.jpg": "090ed49dcb8984f863abbdbbb280413c",
"assets/assets/WAC/Picture7.jpg": "7bdf87787fac9ffde9490bbe9771281e",
"assets/assets/WAC/Picture8.jpg": "af10a987e87e527ba139da0c1aca2bba",
"assets/assets/WAC/Picture9.jpg": "9f165eaa7f7b7648451983b4557fb590",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/fonts/MaterialIcons-Regular.otf": "7b80143d682b9c613d77fb60b76a29cf",
"assets/NOTICES": "6309f5207897379ea346302636489b18",
"assets/packages/o3d/assets/model-viewer.min.js": "7f3dd99a5c27b30d285da8e8fd969b18",
"assets/packages/o3d/assets/template.html": "24a1f29951029adea5122572451138fc",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "ae9b5157fc07048005db91aabb094c73",
"/": "ae9b5157fc07048005db91aabb094c73",
"main.dart.js": "3f0be1ef4f7be05cabadeba4e92398be",
"manifest.json": "3ea76a7b28ea4d17d4dd2b2fd2fedce9",
"version.json": "83a2869b011748a9a2693e10eb1d9c45"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.bin.json",
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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

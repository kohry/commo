import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import crawler

list = [
# "PPOMPPU",
# "BOBAE",
# "RULIWEB",
# "INVEN",
# "SLR",
# "FM",
# "UNIV",
"DOGDRIP",
# "CLIEN",
# "FOMOS",
# "MLB",
# "DDANZI",
# "INSTIZ",
# "YGOSU",
# "NATE",
# "DC",
# "TODAY"
]

cred = credentials.Certificate("commo-d07de-firebase-adminsdk-1vlkw-8ba45418c0.json")

firebase_admin.initialize_app(cred, {
  'projectId': 'commo-d07de',
})

db = firestore.client()


for site in list :
    for post in crawler.fetch(site) :
        doc_ref = db.collection(u'posts').document(post['title'])
        doc_ref.set(post)


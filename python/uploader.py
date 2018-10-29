import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Use the application default credentials
# cred = credentials.ApplicationDefault()


# firebase_admin.initialize_app(cred)

cred = credentials.Certificate("commo-d07de-firebase-adminsdk-1vlkw-8ba45418c0.json")

firebase_admin.initialize_app(cred, {
  'projectId': 'commo-d07de',
})

db = firestore.client()

doc_ref = db.collection(u'users').document(u'alovelace')
doc_ref.set({
    u'first': u'Ada',
    u'last': u'Lovelace',
    u'born': 1815
})

doc_ref = db.collection(u'users').document(u'aturing')
doc_ref.set({
    u'first': u'Alan',
    u'middle': u'Mathison',
    u'last': u'Turing',
    u'born': 1912
})

users_ref = db.collection(u'users')
docs = users_ref.get()

for doc in docs:
    print(u'{} => {}'.format(doc.id, doc.to_dict()))

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import storage
from random import shuffle
import urllib.request
import hashlib
from random import randint

from selenium import webdriver
import os

print('start')

list = [
    "PPOMPPU"
    # "BOBAE",
    # "RULIWEB",
    # "INVEN",
    # "SLR",
    # "FM",
    # "UNIV",
    # "DOGDRIP",
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

def prepareWebDriver() :
    phantomjs_path = "C://webdriver//chromedriver.exe"
    # phantomjs_path = "/usr/lib/chromium-browser/chromedriver"

    # br = webdriver.PhantomJS(executable_path=phantomjs_path, service_log_path=os.path.devnull)
    options = webdriver.ChromeOptions()
    # options.add_argument('headless')
    br = webdriver.Chrome(executable_path=phantomjs_path, service_log_path=os.path.devnull, chrome_options=options)
    return br

from selenium import webdriver
import os
import traceback
import time
import datetime
import re
import random

# title 등에서 나오는 지저분한 형태 다 교체
def convert(str) :
    a = re.sub("[\(\[\<].*?[\>\)\]]", "", str)
    b = a.split("\n")[0].strip()
    return b

# 링크를 가지고 안에 있는 것들을 빼낸다.
def get_content(site, url, title) :

    br = prepareWebDriver()
    br.get(url)

    if site == "PPOMPPU":
        text = br.find_element_by_class_name("cont").text
        image_list = [] # href만을 따온다.
        storage_image_list = [] # 이미지 storage 경로를 따온다.
        try :
            for img in br.find_element_by_class_name("cont").find_elements_by_tag_name("img") :
                image_href = img.get_attribute("src") # 이미지의 링크를 따와서
                image_list.append(image_href)

                upload_storage_image_key = upload_image_storage(image_href, title)
                storage_image_list.append(upload_storage_image_key)

        except :
            print("error:")
            traceback.print_exc()
    br.quit()

    return text, image_list, storage_image_list

    # text split당 루프를 돌면서, 하나하나 저장을 한다음에, 주제 도출을 한다. 총 3개

def upload_image_storage(href,title) :
    st = storage.bucket()

    # 0~100사이의 대충 아무 파일이나 잡고 저장한다.
    outfile = str(randint(0, 100))
    urllib.request.urlretrieve(href, outfile)

    imageKey = hashlib.sha1(title.encode("utf-8")).hexdigest() + str(time.time())

    # 그리고 이미지 키에 따라서 저장한다.
    blob = st.blob(imageKey)

    with open(outfile, 'rb') as my_file :
        blob.upload_from_file(my_file)

    return imageKey

def fetch(site, br) :

    timestamp = datetime.datetime.fromtimestamp(time.time()).strftime('%Y-%m-%d %H:%M')
    list =[]

    if site == "PPOMPPU":

        br.get('http://m.ppomppu.co.kr/new/#hot_bbs')
        try:
            list = br.find_element_by_id("mainList").find_elements_by_tag_name("li")
        except:
            print("not parsed from the start")
        result = []
        content = []
        for i in list:
            try :
                title = str(i.find_element_by_class_name("main_text02").text).replace("/" ,"_")
                if "공지" in title :
                    continue
                key = str(time.time()) + "." + str(random.randint(1 ,10000))
                title = convert(title)
                href = str(i.find_element_by_tag_name("a").get_attribute("href"))

                text, image, storage_source = get_content(site, href, title) # text 와 image의 링크 및 image source파일 (storage에 저장된거) 모두를 빼온다.

                comment_count = str(i.find_element_by_class_name("main_list_comment").text)
                result.append({'title' : title, 'href' : href, 'comment_count' : comment_count, 'site' :site, 'timestamp': timestamp, 'key' : key})
                content.append({'key' : key, 'text' : text, 'image' : image , 'timestamp': timestamp, 'title':title, 'storage_source' : storage_source  }) # 이미지 텍스트 저장.

            except:
                print("error:")
                traceback.print_exc()
        print(result)

    return result, content

# cred = credentials.Certificate("/home/pi/commo/commo/python/commo-d07de-firebase-adminsdk-1vlkw-8ba45418c0.json")
cred = credentials.Certificate("commo-d07de-firebase-adminsdk-1vlkw-8ba45418c0.json")

firebase_admin.initialize_app(cred, {
    'projectId': 'commo-d07de',
    'storageBucket' : 'commo-d07de.appspot.com'
})

db = firestore.client()

br = prepareWebDriver()

result_list = []
content_list = []

for site in list :
    tup = fetch(site, br)
    result_list = tup[0]
    content_list = tup[1]

shuffle(result_list)

for post in result_list:
    doc_ref = db.collection(u'posts_temp').document(post['title'])
    try :
        doc_ref.create(post)
    except :
        pass

for content in content_list:
    doc_ref = db.collection(u'posts_content').document(content['title'])
    try :
        doc_ref.create(content)
    except :
        pass

br.quit()



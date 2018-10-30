from selenium import webdriver
import os
import traceback


def fetch(site) :

    if site == "PPOMPPU":

        br.get('http://m.ppomppu.co.kr/new/#hot_bbs')
        list = br.find_element_by_id("mainList").find_elements_by_tag_name("li")
        result = []
        for i in list:
            try :
                title = str(i.find_element_by_class_name("main_text02").text).replace("/","_")
                href = str(i.find_element_by_tag_name("a").get_attribute("href"))
                comment_count = str(i.find_element_by_class_name("main_list_comment").text)
                result.append({'title' : title, 'href' : href, 'comment_count' : comment_count, 'site':site })
            except:
                print("error:")
                traceback.print_exc()
        print(result)

    if site == "BOBAE":

        br.get('http://m.bobaedream.co.kr/board/new_writing/best')
        list = br.find_element_by_class_name("rank").find_elements_by_class_name("info")
        result = []
        for i in list:
            try:
                title = str(i.find_element_by_class_name("cont").text).strip().replace("/","_")
                href = str(i.find_element_by_tag_name("a").get_attribute("href")).strip()
                comment_count = str(i.find_element_by_class_name("num").text)
                result.append({'title': title, 'href': href, 'comment_count': comment_count, 'site':site })
            except:
                print("error:")
                traceback.print_exc()
        print(result)

    if site == "RULIWEB":

        br.get('https://m.ruliweb.com/best')
        list = br.find_element_by_id("board_list").find_elements_by_class_name("title")
        result = []
        for i in list:
            try:
                title = str(i.find_element_by_class_name("subject_link").text).strip().replace("/","_")
                href = str(i.find_element_by_tag_name("a").get_attribute("href")).strip()
                comment_count = str(i.find_element_by_class_name("num").text)
                result.append({'title': title, 'href': href, 'comment_count': comment_count, 'site':site })
            except:
                print("error:")
                traceback.print_exc()
        print(result)

    if site == "INVEN":

        br.get('http://m.inven.co.kr/board/powerbbs.php?come_idx=2097')
        list = br.find_element_by_id("boardList").find_elements_by_class_name("articleSubject")
        result = []
        for i in list:
            try:
                title = str(i.find_element_by_class_name("title").text).strip().replace("/","_")
                href = str("http://m.inven.co.kr" + i.find_element_by_tag_name("a").get_attribute("href")).strip()
                comment_count = str("X")
                result.append({'title': title, 'href': href, 'comment_count': comment_count, 'site':site })
            except:
                print("error:")
                traceback.print_exc()
        print(result)

    if site == "SLR":

        br.get('http://m.slrclub.com/l/hot_article')
        list = br.find_element_by_class_name("list").find_elements_by_class_name("article")
        result = []
        for i in list:
            try:
                title = str(i.find_element_by_tag_name("a").text).strip().replace("/","_")
                href = str("http://m.slrclub.com/l/hot_article" + i.find_element_by_tag_name("a").get_attribute("href")).strip()
                comment_count = str(i.parent.find_element_by_class_name("cmt2").text)
                result.append({'title': title, 'href': href, 'comment_count': comment_count, 'site':site })
            except:
                print("error:")
                traceback.print_exc()
        print(result)

    if site == "FM":

        br.get('https://m.fmkorea.com/best')
        list = br.find_element_by_class_name("fm_best_widget").find_elements_by_class_name("li")
        result = []
        for i in list:
            try:
                title = str(i.find_element_by_class_name("title").text).strip().replace("/","_")
                href = str("https://m.fmkorea.com/best" + i.find_element_by_tag_name("a").get_attribute("href")).strip()
                comment_count = str("X")
                result.append({'title': title, 'href': href, 'comment_count': comment_count, 'site':site })
            except:
                print("error:")
                traceback.print_exc()
        print(result)


    if site == "UNIV":

        br.get('http://m.humoruniv.com/board/list.html?table=pds')
        list = br.find_element_by_id("list_body").find_elements_by_class_name("list_body_href")
        result = []
        for i in list:
            try:
                title = str(i.find_element_by_class_name("li").text).strip().replace("/","_")
                href = str("http://m.humoruniv.com/board/list.html?table=pds" + i.get_attribute("href")).strip()
                comment_count = str(i.find_element_by_class_name("ok_num").text).strip()
                result.append({'title': title, 'href': href, 'comment_count': comment_count, 'site':site })
            except:
                print("error:")
                traceback.print_exc()
        print(result)


    if site == "DOGDRIP":
        br.implicitly_wait(5)
        br.get('https://www.dogdrip.net/dogdrip')
        list = br.find_element_by_class_name("list").find_elements_by_tag_name("li")
        result = []
        for i in list:
            try:
                title = str(i.find_element_by_tag_name("a").text).strip().replace("/","_")
                href = str(i.find_element_by_tag_name("a").get_attribute("href")).strip()
                comment_count = str("X").strip()
                result.append({'title': title, 'href': href, 'comment_count': comment_count, 'site':site })
            except:
                print("error:")
                traceback.print_exc()
        print(result)


    if site == "CLIEN":

        br.get('https://m.clien.net/service/group/clien_all?&od=T33')
        list = br.find_element_by_class_name("content_list").find_elements_by_class_name("list_item")
        result = []
        for i in list:
            try:
                title = str(i.find_element_by_class_name("list_subject").text).strip().replace("/","_")
                href = str("https://m.clien.net/" + i.find_element_by_tag_name("a").get_attribute("href")).strip()
                comment_count = str("X").strip()
                result.append({'title': title, 'href': href, 'comment_count': comment_count, 'site':site })
            except:
                print("error:")
                traceback.print_exc()
        print(result)


    if site == "FOMOS":

        br.get('http://m.fomos.kr/talk/article_list?bbs_id=1')
        list = br.find_element_by_id("contents").find_elements_by_class_name("ut_item")
        result = []
        for i in list:
            try:
                title = str(i.find_element_by_tag_name("a").text).strip().replace("/","_")
                href = str("http://m.fomos.kr" + i.find_element_by_tag_name("a").get_attribute("href")).strip()[1:]
                comment_count = str("X").strip()
                result.append({'title': title, 'href': href, 'comment_count': comment_count, 'site':site })
            except:
                print("error:")
                traceback.print_exc()
        print(result)

    if site == "MLB":
        br.implicitly_wait(5)
        br.get('http://mlbpark.donga.com/mlbpark/b.php?b=bullpen')
        list = br.find_element_by_class_name("tbl_type01").find_elements_by_tag_name("tr")
        result = []
        for i in list:
            try:
                title = str(i.find_element_by_class_name("t_left").text).strip().replace("/","_")
                href = str(i.find_element_by_tag_name("a").get_attribute("href")).strip()
                comment_count = str("X").strip()
                result.append({'title': title, 'href': href, 'comment_count': comment_count, 'site':site })
            except:
                print("error:")
                traceback.print_exc()
        print(result)

    if site == "DDANZI":
        br.implicitly_wait(3)
        br.get('http://www.ddanzi.com/index.php?mid=free&statusList=HOT%2CHOTBEST')
        list = br.find_element_by_id("list_style").find_elements_by_class_name("title")
        result = []
        for i in list:
            try:
                title = str(i.find_element_by_tag_name("a").text).strip().replace("/","_")
                href = str(i.find_element_by_tag_name("a").get_attribute("href")).strip()
                comment_count = str("X").strip()
                result.append({'title': title, 'href': href, 'comment_count': comment_count, 'site':site })
            except:
                print("error:")
                traceback.print_exc()
        print(result)


    if site == "INSTIZ":
        br.implicitly_wait(3)
        br.get('https://www.instiz.net/bbs/list.php?id=pt&srt=3')
        list = br.find_element_by_id("mainboard").find_elements_by_id("subject")
        result = []
        for i in list:
            try:
                title = str(i.find_element_by_tag_name("a").text).strip().replace("/","_")
                href = str(i.find_element_by_tag_name("a").get_attribute("href")).strip()
                comment_count = str("X").strip()
                result.append({'title': title, 'href': href, 'comment_count': comment_count, 'site':site })
            except:
                print("error:")
                traceback.print_exc()
        print(result)



    if site == "YGOSU":
        br.implicitly_wait(3)
        br.get('https://www.ygosu.com/community/real_article')
        list = br.find_element_by_class_name("bd_list").find_elements_by_class_name("tit")
        result = []
        for i in list:
            try:
                title = str(i.find_element_by_tag_name("a").text).strip().replace("/","_")
                href = str(i.find_element_by_tag_name("a").get_attribute("href")).strip()
                comment_count = str("X").strip()
                result.append({'title': title, 'href': href, 'comment_count': comment_count, 'site':site })
            except:
                print("error:")
                traceback.print_exc()
        print(result)

    if site == "NATE":
        br.implicitly_wait(3)
        br.get('https://m.pann.nate.com/talk/today')
        list = br.find_element_by_class_name("list").find_elements_by_tag_name("li")
        result = []
        for i in list:
            try:
                title = str(i.find_element_by_tag_name("a").text).strip().replace("/","_")
                href = str(i.find_element_by_tag_name("a").get_attribute("href")).strip()
                comment_count = str("X").strip()
                result.append({'title': title, 'href': href, 'comment_count': comment_count, 'site':site })
            except:
                print("error:")
                traceback.print_exc()
        print(result)


    if site == "DC":
        br.implicitly_wait(3)
        br.get('http://gall.dcinside.com/board/lists/?id=hit')
        list = br.find_element_by_class_name("gall_list").find_elements_by_class_name("gall_tit")
        result = []
        for i in list:
            try:
                title = str(i.find_element_by_tag_name("a").text).strip().replace("/","_")
                href = str(i.find_element_by_tag_name("a").get_attribute("href")).strip()
                comment_count = str("X").strip()
                result.append({'title': title, 'href': href, 'comment_count': comment_count, 'site':site })
            except:
                print("error:")
                traceback.print_exc()
        print(result)


    if site == "TODAY":
        br.implicitly_wait(3)
        br.get('http://www.todayhumor.co.kr/board/list.php?table=bestofbest')
        list = br.find_elements_by_class_name("subject")
        result = []
        for i in list:
            try:
                title = str(i.find_element_by_tag_name("a").text).strip().replace("/","_")
                href = str(i.find_element_by_tag_name("a").get_attribute("href")).strip()
                comment_count = str("X").strip()
                result.append({'title': title, 'href': href, 'comment_count': comment_count, 'site':site })
            except:
                print("error:")
                traceback.print_exc()
        print(result)

    return result

########################################
# ######################################################

# phantomjs_path = "C://phantomjs//bin//phantomjs.exe"
phantomjs_path = "C://webdriver//chromedriver.exe"

# br = webdriver.PhantomJS(executable_path=phantomjs_path, service_log_path=os.path.devnull)
options = webdriver.ChromeOptions()
options.add_argument('headless')
br = webdriver.Chrome(executable_path=phantomjs_path, service_log_path=os.path.devnull, chrome_options=options)

# fetch("PPOMPPU")
# fetch("BOBAE")
# fetch("RULIWEB")
# fetch("INVEN")
# fetch("SLR")
# fetch("FM")
# fetch("UNIV")
# fetch("DOGDRIP")
# fetch("CLIEN")
# fetch("FOMOS")
# fetch("MLB")
# fetch("DDANZI")
# fetch("INSTIZ")
# fetch("YGOSU")
# fetch("NATE")
# fetch("DC")
# fetch("TODAY")
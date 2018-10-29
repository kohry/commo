from selenium import webdriver
import os
import traceback

def fetch(site) :


    if site == "PPOMPPU":

        br.get('http://m.ppomppu.co.kr/new/#hot_bbs')
        list = br.find_element_by_id("mainList").find_elements_by_tag_name("li")
        for i in list:
            try :
                title = i.find_element_by_class_name("main_text02").text
                href = i.find_element_by_tag_name("a").get_attribute("href")
                print(title)
                print(href)
            except:
                print("error:")
                traceback.print_exc()


    if site == "BOBAE":

        br.get('http://m.bobaedream.co.kr/board/new_writing/best')
        list = br.find_element_by_id("rank").find_elements_by_tag_name("info")
        for i in list:
            try:
                title = str(i.find_element_by_class_name("cont").text).strip()
                href = str(i.find_element_by_tag_name("a").get_attribute("href")).strip()
                print(title)
                print(href)
            except:
                print("error:")
                traceback.print_exc()


##############################################################################################

phantomjs_path = "C://phantomjs//bin//phantomjs.exe"
br = webdriver.PhantomJS(executable_path=phantomjs_path, service_log_path=os.path.devnull)

# fetch("PPOMPPU")
fetch("BOBAE")


from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select
from selenium.common.exceptions import NoSuchElementException
import time
import pandas as pd

PATH = 'C:\Program Files (x86)\chromedriver.exe'
driver = webdriver.Chrome(PATH)

driver.get('https://db.ygoprodeck.com/pack-open/')
nameList = []
rarityList = []
priceList = []

#find desired pack
def getPack():
    select = Select(driver.find_element(By.ID, "filter-sort"))
    select.select_by_visible_text('Release Date')
    #wait for it to be sorted by release date
    time.sleep(2)
    #click newest released pack
    driver.find_element(By.XPATH, '//*[@id="pack-select"]/button[161]').click()

def openPack():
    try:
        #once desired pack is chosen flip cards
        time.sleep(1)
        driver.find_element(By.ID, 'flip').click()

        #record data into dictionary
        
        #first get card name
        cardName = driver.find_elements(By.CLASS_NAME, 'flip-meta-name')
        for i in cardName:
            nameList.append(i.text)
        #second get card rarity
        #Try to pool all rarities into one by finding 'card-' in name.
        cardRarity = driver.find_elements(By.XPATH, '//*[@id="card-holder"]/figure/figcaption/span[2]/span[2]')

        for j in cardRarity:
            rarityList.append(j.text)


        #third get card price
        findPrice = driver.find_elements(By.XPATH, "//a[contains(text(), '$')]")
        for z in findPrice:
            priceList.append(z.text)

        diction = {"Card Name" : nameList,
                   "Rarity" : rarityList,
                   "Price" : priceList}

        dict_items = diction.items()
        dictList = list(dict_items)
        df = pd.DataFrame(diction)

        #hit retry button
        time.sleep(3)
        driver.find_element(By.ID, 'retry').click()

        return df
    except:
        print("Error")

def main():
    col = ['Card Name', 'Rarity', 'Price']
    #go to desired pack
    getPack()
    #run 288 times to open one case and see rate of return.
    for i in range(240):
        testDF = openPack()
    
    testDF.to_excel("Maximum_Gold_ROI_v2.xlsx")

                
if __name__ == "__main__":
    main()

import requests

def get_model_count():
    totalModels=0
    checkedCreators=0
    currentPage=1
    totalCreators=requests.get(f"https://civitai.com/api/v1/creators?limit=1").json()['metadata']['totalItems']
    while checkedCreators < totalCreators:
        creatorsResponse = requests.get(f"https://civitai.com/api/v1/creators?limit=5&page={currentPage}").json()  
        for creator in creatorsResponse['items']:
            checkedCreators += 1
            if "modelCount" in creator:
                totalModels += creator['modelCount']
        currentPage+=1
        print("page: ",currentPage)
        print("checkedCreators: ",checkedCreators)
        print("totalModels: ",totalModels)
    return totalModels

print(f"Total number of models hosted: {get_model_count()}")
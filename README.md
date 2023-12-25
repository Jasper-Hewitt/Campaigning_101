# Campaigning_101

even though the post created column says CST. IT is still in Taiwan time so that's weird lol.

### serial_number
The serial numbers are only based on the posts that fall within the time periods of each candidates' campaign.
If I get new data I will have to add serial numbers accordingly...

After labelling the save_for_label_df (this contains only the posts where other politicians are mentinoned). I will have to merge it back with filtered_df (this contains all the posts). I will have to merge on the common columns so as not to create duplicates!

### GPT 4 
I can maybe try to use some GPT 4 in the process after I have labelled around 100 rows. 

### started running dates 
賴清德: 12/04/23
侯友宜: 17/05/2023 （pre-official）
柯文哲： 16/05/2023
郭台銘：28/08/2023 until 24/11/2023

In other format
侯友宜: 2023-05-17         
柯文哲：2023-05-16 
郭台銘：2023-08-28  until 2023-11-24 

### keywords
Ok this appears to be complete but I might want to write it out in a table so I am sure that I have all the keywords. It appears we are 
complete here. Check notion...

柯文哲:	    "民進黨" OR "民主進步黨" OR "賴" OR "侯" OR "國民黨" OR "郭" OR "藍白" OR "蕭" OR "蔡" OR "馬前總統" OR "馬英九" OR "朱" OR "趙" OR "賴佩霞" OR "藍綠" OR "執政黨" OR "藍營" OR "綠營" OR "主流民意大聯盟"
賴清德:		"侯" OR "國民黨" OR "民眾黨" OR "柯" OR "郭" OR "藍白" OR "吳"  OR "馬前總統" OR "馬英九" OR "朱" OR "趙" OR "賴佩霞" OR "在野黨" OR "藍營" OR "主流民意大聯盟"
侯友宜:		"民進黨" OR "民主進步黨" OR "民眾黨" OR "柯" OR "郭" OR "賴" OR "藍白" OR "蕭" OR "蔡" OR "賴佩霞" OR "執政黨" OR "主流民意大聯盟" OR "吳" OR "綠營"
郭台銘:		"民進黨" OR "民主進步黨" OR "賴" OR "侯" OR "國民黨" OR "藍白" OR "蔡"  OR "馬前總統" OR "馬英九" OR "朱" OR "趙" OR "民眾黨" OR "執政黨" OR "藍營" OR "綠營" OR "主流民意大聯盟" OR "吳" OR "蕭" OR "柯"

feedback professor: 在實際的經驗上可以發現，候選人有時也會使用「藍白陣營」、「主流民意大聯盟」、「執政黨」、「在野黨」可以考慮納入。
2.因為藍白合或在野合作的歷史，所以「柯郭配」、「郭柯配」、「柯侯配」、「侯柯配」、「郭賴配」等名詞也會出現，同時有些名詞所指涉的對象橫跨單一政黨陣營，所以在coding上可能需要分別加上次數。
3.總統候選人的副手確定後(藍白破局後)，有關候選人部分的名詞需要改變，但原則上仍舊是以總統候選人為主。




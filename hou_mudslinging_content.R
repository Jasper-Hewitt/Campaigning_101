#creating master csv
library(tidyverse)
library(dplyr)
library(tidytext)
library(stringr)
library(readtext)
library(lubridate)
library(purrr)
library(readxl)
library(ggplot2)
library(quanteda)
library(jiebaR)
library(readtext)
library(pdftools)
library(lubridate)
library(purrr)
library(wordcloud2)
library(tm)
library(topicmodels)

setwd("/Users/jasperhewitt/Desktop/github_repos/Campaigning_101/data")

# # # # # # # # # # # # # # # # # # 侯友宜！ # # # # # # # # # # # # # # # # # # # # # # # # 
#----------——-——-————————————-——— 侯友宜 針對民進黨 ----------——-——-————————————-——— # 

master_df <- read.csv("/Users/jasperhewitt/Desktop/github_repos/Campaigning_101/data/all_attacks.csv")

#only keep relevant columns 
master_df <- master_df %>%
  select('serial_number', 'User.Name', 'combined_text', 'attack', 'target')

#filter so User.Name == houyuih
master_df <- master_df %>%
  filter(User.Name == 'houyuih')

#search pattern 侯友宜 critcize 民進黨
#search_pattern <- "民進黨|民主進步黨|賴|蔡|綠營|蕭"


search_pattern <- "民進黨|民主進步黨|賴|蔡|綠營|蕭"
#search_pattern <- "民眾黨|柯|藍白"

#  mutate(important_sentences = str_split(combined_text, "[。？！]")) %>% #split it into sentences
#  #find the sentences that contain some of our keywords, and paste that sentences into the important_sentences column
#  mutate(important_sentences = map(important_sentences, ~ .[str_detect(., regex(search_pattern, ignore_case = TRUE))])) %>%
  #unnest the columns, so each important sentence will get their own row. just like 'explode in pandas' 
#  unnest(important_sentences)%>%
#  distinct() %>%
  # Filter rows where 'target' contains one of the terms in the search pattern

master_df <- master_df %>%
  filter(str_detect(target, regex(search_pattern, ignore_case = TRUE)))

unique_serial_numbers <- length(unique(master_df$serial_number))
cat("Number of unique serial numbers:", unique_serial_numbers, "\n")

#show len master_df
nrow(master_df)

master_fert_df <- master_df

#add doc_id
master_fert_df <- master_fert_df %>% 
  mutate(doc_id = row_number())

#load stopwords 
stopwords <- readLines("stopwords_zh_trad.txt",
                       encoding = "UTF-8")

#check len of stopwrods
length(stopwords)

#load custom dictionary 
my_seg <- worker(bylines = T,
                 user = "customdict.txt",
                 symbol = T)

## word tokenization
master_fert_word <- master_fert_df %>%
  unnest_tokens(
    output = word,
    input = combined_text,  # the name of the column we are plotting
    token = function(x)
      segment(x, jiebar = my_seg)
  ) %>%
  group_by(doc_id) %>%
  mutate(word_id = row_number()) %>% # create word index within each document
  ungroup

custom_stopwords <- c("繁榮", "面對", "是否", "不要", "一場", "13", "發展", "要求", "政黨", "感謝", "看到", "我要", "完成", "個人", "機會", "包括", "政黨輪替", "表達", "請問", "藍白", "藍白", "柯文哲", "民眾黨","參選人", "參選","無法", "目標", "力量","不斷", "完全", "實現", "希望", '政策', '立委', '改變', '支持', '告訴', '願意', '推動', '承諾', '這片', '再次', '最大', '中央', '重要', '到底', '建設','期待', 
                      '帶給', '趙少康', '選舉', '立刻', '必須', '清德', '清楚', '卻是', '主張', 
                      '變成', '絕對', '區域', '侯友', '選擇', '更是', '主席', '不能', '確是', '還給',  
                      "執政", "總統", "國民黨", "2024", "政治", "如今", "在此", '最後', '全國', "賴清德", "中華民國", "宜來", "未來", "侯友宜", "一定", "民眾", "就讓",
                      "民進黨", "人民", "政府", "國家", "報導", "可能", "指出", "認為", "新聞網", "國際", 
                      "應該", "可能", "提出", "過去", "現在", "進行","今天", "相關", "社會",
                      "議題", "很多", "undo", "需要", "需求", "已經", "目前", "今年", "透過",
                      "地方", "沒有", "記者", "成為", "持續", "市場", "表示", "台灣", "造成",
                      "不少", "原因", "影響", "問題", "/", "10", "20", "30", "一起", "市長", "市民", "朋友",
                      "城市", "12", "11", "https")  # specific words about 生育率# specific words about 生育率
stopwords <- c(stopwords, custom_stopwords)

stopwords
length(stopwords)

#___________# WORDCLOUD AND WORD FREQUENCY LIST #__________# 

## create word freq list
master_word_freq <- master_fert_word %>%
  mutate(word = str_trim(word)) %>%  # remove whitespaces
  filter(str_length(word) > 1, !word %in% stopwords) %>% # remove single character words and stopwords 
  count(word) %>%
  arrange(desc(n))


#plot wordcloud
master_word_freq %>%
  filter(n > 85) %>%
  filter(nchar(word) >= 2) %>% ## remove one character words because they are usually not really relevant
  wordcloud2(shape = "circle", size = 0.4)
#save wordcloud as image
# wordcloud2(shape = "circle", size = 0.4) %>% 
#   saveWidget("wordcloud_fertility.html", selfcontained = F)

# Select 20 most frequent words
top_20_words <- master_word_freq %>%
  top_n(20, n)

# plot sideways word frequency list
ggplot(top_20_words, aes(x = reorder(word, n), y = n)) + 
  geom_bar(stat = "identity", fill = "skyblue") +
  coord_flip() +
  labs(x = "Words", y = "Count", title = "20 most frequent words in candidates' \n posts about fertility") +
  theme_minimal() +
  theme(text = element_text(family = "Songti SC", size = 20))



#----------——-——-————————————-——— 侯友宜 針對 柯文哲----------——-——-————————————-——— # 



master_df <- read.csv("/Users/jasperhewitt/Desktop/github_repos/Campaigning_101/data/all_attacks.csv")

#only keep relevant columns 
master_df <- master_df %>%
  select('serial_number', 'User.Name', 'combined_text', 'attack', 'target')

#filter so User.Name == houyuih
master_df <- master_df %>%
  filter(User.Name == 'houyuih')

#search pattern 侯友宜 critcize 民進黨
#search_pattern <- "民進黨|民主進步黨|賴|蔡|綠營|蕭"


#search_pattern <- "民進黨|民主進步黨|賴|蔡|綠營|蕭"
search_pattern <- "民眾黨|柯|藍白"
master_df <- master_df %>%
  mutate(important_sentences = str_split(combined_text, "[。？！]")) %>% #split it into sentences
  #find the sentences that contain some of our keywords, and paste that sentences into the important_sentences column
  mutate(important_sentences = map(important_sentences, ~ .[str_detect(., regex(search_pattern, ignore_case = TRUE))])) %>%
  #unnest the columns, so each important sentence will get their own row. just like 'explode in pandas' 
  unnest(important_sentences)%>%
  distinct() %>%
  # Filter rows where 'target' contains one of the terms in the search pattern
  filter(str_detect(target, regex(search_pattern, ignore_case = TRUE)))

unique_serial_numbers <- length(unique(master_df$serial_number))
cat("Number of unique serial numbers:", unique_serial_numbers, "\n")

#show len master_df
nrow(master_df)

master_fert_df <- master_df

#add doc_id
master_fert_df <- master_fert_df %>% 
  mutate(doc_id = row_number())

#load stopwords 
stopwords <- readLines("stopwords_zh_trad.txt",
                       encoding = "UTF-8")

#check len of stopwrods
length(stopwords)

#load custom dictionary 
my_seg <- worker(bylines = T,
                 user = "customdict.txt",
                 symbol = T)

## word tokenization
master_fert_word <- master_fert_df %>%
  unnest_tokens(
    output = word,
    input = important_sentences,  # the name of the column we are plotting
    token = function(x)
      segment(x, jiebar = my_seg)
  ) %>%
  group_by(doc_id) %>%
  mutate(word_id = row_number()) %>% # create word index within each document
  ungroup

custom_stopwords <- c("候選人","記得", "後來", "立法", "第二", "臺灣","越來越","立法院", "行政院長", "發展", "這是", "高喊", 
                      "時期", "導致", "不要", "只能", "看到","當年", "其實", "不會", "蔡英文", 
                      "tsai","ing", "wen", "政黨", "表達", "請問", "藍白", "藍白", "柯文哲", 
                      "民眾黨","參選人", "參選","無法", "目標","政黨輪替", "表達", "請問", "藍白", "藍白", "柯文哲", "民眾黨","參選人", "參選","無法", "目標", "力量","不斷", "完全", "實現", "希望", '政策', '立委', '改變', '支持', '告訴', '願意', '推動', '承諾', '這片', '再次', '最大', '中央', '重要', '到底', '建設','期待', 
                      '帶給', '趙少康', '選舉', '立刻', '必須', '清德', '清楚', '卻是', '主張', 
                      '變成', '絕對', '區域', '侯友', '選擇', '更是', '主席', '不能', '確是', '還給',  
                      "執政", "總統", "國民黨", "2024", "政治", "如今", "在此", '最後', '全國', "賴清德", "中華民國", "宜來", "未來", "侯友宜", "一定", "民眾", "就讓",
                      "民進黨", "人民", "政府", "國家", "報導", "可能", "指出", "認為", "新聞網", "國際", 
                      "應該", "可能", "提出", "過去", "現在", "進行","今天", "相關", "社會",
                      "議題", "很多", "undo", "需要", "需求", "已經", "目前", "今年", "透過",
                      "地方", "沒有", "記者", "成為", "持續", "市場", "表示", "台灣", "造成",
                      "不少", "原因", "影響", "問題", "/", "10", "20", "30", "一起", "市長", "市民", "朋友",
                      "城市", "12", "11", "https")  # specific words about 生育率# specific words about 生育率
stopwords <- c(stopwords, custom_stopwords)

stopwords
length(stopwords)

#___________# WORDCLOUD AND WORD FREQUENCY LIST #__________# 

## create word freq list
master_word_freq <- master_fert_word %>%
  mutate(word = str_trim(word)) %>%  # remove whitespaces
  filter(str_length(word) > 1, !word %in% stopwords) %>% # remove single character words and stopwords 
  count(word) %>%
  arrange(desc(n))


#plot wordcloud
master_word_freq %>%
  filter(n > 3) %>%
  filter(nchar(word) >= 2) %>% ## remove one character words because they are usually not really relevant
  wordcloud2(shape = "circle", size = 0.6)
#save wordcloud as image
# wordcloud2(shape = "circle", size = 0.4) %>% 
#   saveWidget("wordcloud_fertility.html", selfcontained = F)

# Select 20 most frequent words
top_20_words <- master_word_freq %>%
  top_n(20, n)

# plot sideways word frequency list
ggplot(top_20_words, aes(x = reorder(word, n), y = n)) + 
  geom_bar(stat = "identity", fill = "skyblue") +
  coord_flip() +
  labs(x = "Words", y = "Count", title = "20 most frequent words in candidates' \n posts about fertility") +
  theme_minimal() +
  theme(text = element_text(family = "Songti SC", size = 20))

#___________# TOPIC MODELLING #__________# 

master_df <- read.csv("/Users/jasperhewitt/Desktop/github_repos/Campaigning_101/data/all_attacks.csv")


search_pattern <- "民進黨|民主進步黨|賴|蔡|綠營|蕭"
#search_pattern <- "民眾黨|柯|藍白"
master_df <- master_df %>%
  mutate(important_sentences = str_split(combined_text, "[。？！]")) %>% #split it into sentences
  #find the sentences that contain some of our keywords, and paste that sentences into the important_sentences column
  mutate(important_sentences = map(important_sentences, ~ .[str_detect(., regex(search_pattern, ignore_case = TRUE))])) %>%
  #unnest the columns, so each important sentence will get their own row. just like 'explode in pandas' 
  unnest(important_sentences)%>%
  distinct() %>%
  # Filter rows where 'target' contains one of the terms in the search pattern
  filter(str_detect(target, regex(search_pattern, ignore_case = TRUE)))


nrow(master_df)

#import xlsx with additional data for each candidate (party, city, english name, etc.)
#candidate_info <- read_xlsx("/Users/jasperhewitt/Desktop/fertnews/candidates_info.xlsx")

#only keep relevant columns 
master_df <- master_df %>%
  select('serial_number', 'User.Name', 'combined_text', 'attack', 'target')

#filter so User.Name == houyuih
master_df <- master_df %>%
  filter(User.Name == 'houyuih')
nrow(master_df)

#in the combined_text column, only keep the sentences that contain the target. these are the interpunction that may be used
# 。 ？ ！ 

unique_serial_numbers <- length(unique(master_df$serial_number))
cat("Number of unique serial numbers:", unique_serial_numbers, "\n")

stopwords <- c(stopwords, custom_stopwords)

# Function to remove one-character words
remove_one_char_words <- function(word_list){
  word_list[sapply(word_list, function(word) nchar(word) > 1)]
}

# Segmentation and removal of stopwords
master_df$seg_content <- sapply(master_df$combined_text, function(row) {
  words <- segment(code = row, jiebar = my_seg)
  words <- words[!words %in% stopwords]
  remove_one_char_words(words)
})

# Create Corpus from the content column
corpus <- Corpus(VectorSource(master_df$seg_content))

# Document Term Matrix
dtm <- DocumentTermMatrix(corpus)

# Run LDA
k <- 3  # Number of topics
lda_model <- LDA(dtm, k, method = "Gibbs", control = list(seed = 123, burnin = 500, iter = 5000, thin = 100))

# Get the terms from the model
terms(lda_model, 5)  # Returns the top 15 terms for each topic








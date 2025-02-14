# Fomasi, M. (2024). WWWTALK_Scraper (Versione 1.0) [R; Windows (64x)]

# WWWTALKCopyright © 1996-2003 The World Wide Web History Project and Arcady Press

# Legal info: http://1997.webhistory.org/legal.html")

# This project is not affiliated with the The World Wide Web History Project and Arcady Press
#System set up. Download and open libraries
Sys.setenv(Lang="en")

#Install packages and open libraries

if (!require("rvest")) install.packages("rvest")
library(rvest)

if (!require("httr2")) install.packages("httr2")
library(httr2)

if (!require("dplyr")) install.packages("dplyr")
library(dplyr)

if (!require("stringr")) install.packages("stringr")
library(stringr)

if (!require("tidyr")) install.packages("tidyr")
library(tidyr)

if (!require("fs")) install.packages("fs")
library(fs)

if (!require("openxlsx")) install.packages("openxlsx")
library(openxlsx)

if (!require("lubridate")) install.packages("lubridate")
library("lubridate")

if (!require("beepr")) install.packages("beepr")
library("beepr")

if (!require("ggplot2")) install.packages("ggplot2")
library("ggplot2")

#Import directories URL

URL<- c("http://1997.webhistory.org/www.lists/www-talk.1991/subject.html#start", #Create a vector with URL
        "http://1997.webhistory.org/www.lists/www-talk.1992/subject.html#start",
        "http://1997.webhistory.org/www.lists/www-talk.1993q1/subject.html#start",
        "http://1997.webhistory.org/www.lists/www-talk.1993q2/subject.html#start",
        "http://1997.webhistory.org/www.lists/www-talk.1993q3/subject.html#start",
        "http://1997.webhistory.org/www.lists/www-talk.1993q4/subject.html#start",
        "http://1997.webhistory.org/www.lists/www-talk.1994q1/subject.html#start",
        "http://1997.webhistory.org/www.lists/www-talk.1994q2/subject.html#start",
        "http://1997.webhistory.org/www.lists/www-talk.1994q3/subject.html#start",
        "http://1997.webhistory.org/www.lists/www-talk.1994q4/subject.html#start",
        "http://1997.webhistory.org/www.lists/www-talk.1995q1/subject.html#start",
        "http://1997.webhistory.org/www.lists/www-talk.1995q2/subject.html#start",
        "http://1997.webhistory.org/www.lists/www-talk.1995q3/subject.html#start",
        "http://1997.webhistory.org/www.lists/www-talk.1995q4/subject.html#start")


#Select Titles, Authors, Date

List_title<-list() #Create an empty list
List_authors<-list()#Create an empty list
List_date<-list()#Create an empty list
list_html<-list()#Create an empty list

for (i in 1:14) { #Start the loop
  
  HTML <- read_html(URL[i]) #Read html
  STRING <- as.character(HTML) #Convert in character
  
  list_html[i]<-STRING #Store directory's html
  
  title <- data.frame(regmatches(STRING, gregexpr("<b>(.*?)</b>", STRING))) #exctract titles
  
  title<-title[-(1:5),] #Remove Headers
  
  title <- head(title, -4) # Remove Footers
  
  List_title[[i]]<-title #Save Titles
  
  mix <- data.frame(regmatches(STRING, gregexpr("<a href(.*?)<b>", STRING))) #Select authors and date
  
  mix<-mix[-(1:2),] #Remove the headers
  
  mix <- head(mix, -1) # Remove Footers
  
  authors <-str_extract_all(mix, 'html\">(.*?)</a>') #Select authors
  
  List_authors[[i]]<-authors #Save authors
  
  date<-str_extract_all(mix, '<i>(.*?)</i>') #Select date
  
  List_date[[i]]<-date #Save date
  
} #End of the loop

HTML_df<-do.call(rbind,   list_html) 

#Correcting Directories

#1994q2
List_authors[[7]] <- c(List_authors[[7]], List_authors[[8]][1]) #Move First author of 1994q2 as last author of 1994q1

List_authors[[8]] <- List_authors[[8]][-1] #Remove First author of 1994q2 

List_title[[7]] <- append(List_title[[7]], "Re: Error Condition Re:") # Add tittles as last Title 1994q2

List_date[[7]]<-c(List_date[[7]], List_date[[8]][1])#Move First List_date of 1994q2 as last List_date of 1994q1

List_date[[8]] <- List_date[[8]][-1] #Remove First List_date of 1994q2 

# Repeate the operation for 1994q4

List_authors[[9]] <- c(List_authors[[9]], List_authors[[10]][1])

List_authors[[10]] <- List_authors[[10]][-1]

List_title[[9]] <- append(List_title[[9]], "Re: Error Condition Re:")

List_date[[9]]<-c(List_date[[9]], List_date[[10]][1])

List_date[[10]] <- List_date[[10]][-1]


#Merging Authors, Titles and Date

Storing_list<-list()

for (i in 1:14) {   #Start main loop
  
  Merging_list<-list() #Create an empty list to store the results of the the sub loop
  
  for ( x in 1:length(List_authors[[i]])) { #Start sub loop
    
    Test<- data.frame(List_authors[[i]][[x]]) #Import list_authors
    
    colnames(Test)[1] <- "Authors" #Rename first column in List_authors
    
    current<-List_title[[i]] #Select current List_title
    
    Test[2]<- current[x] #Import List_title
    
    colnames(Test)[2]<- "Title"#Rename second column in Title 
    
    Merging_list[[x]]<-Test #Save iteration 
    
    current<-List_date[[i]] #Select list_date
    
    Test[3]<-current[x] #Import list_date
    
    colnames(Test)[3]<-"Date" #Rename column
    
    Merging_list[[x]]<-Test #Save the result of the sub loop
  }
  
  Storing_list[[i]]<-Merging_list #Save sub loop into the main list and ressta
  
}

Df<-bind_rows(Storing_list)

#Cleaning

Df_cleaning<-Df%>%
  mutate(Authors=gsub('html">', "", Authors))%>%  #Remove html"> from Authors
  mutate(Authors=gsub("</a>", "", Authors))%>%    #Remove <a/> from Authors
  mutate(Title=gsub("<b>","",Title))%>%           #Remove <b> from Title
  mutate(Title=gsub("</b>","",Title))%>%          #Remove </b> from Title
  mutate(Date=gsub("<i>","",Date))%>%             #Remove <i> from Date
  mutate(Date=gsub("</i>","",Date))%>%            #Remove <i/> from Date
  mutate(Date=gsub("  "," ", Date))%>%            #Replace a double space with a single space
  mutate(Complex=Date)%>%                         #Copy Date column
  separate(Complex, into = c("Var1", "Var2", "Var3","Var4","Var5", "Var6"), sep = " ", fill = "right")%>% #Separate Complex dates in columns on the right                           #Remove Complex 
  unite(Var1, Var2, Var3, Var4, sep="-")%>% #Merge columns with date elements
  mutate(Var1=gsub("-19","-", Var1))%>%   #Remove 19 before the year
  mutate(Var1 = ifelse(grepl("^[1-9]-", Var1), paste0("0", Var1), Var1))%>%
  rename(Summary=Date, Date=Var1,Time = Var5, Time_zone = Var6)

Problematic_date<-Df_cleaning[nchar(Df_cleaning$Date) != 9, ]%>% 
  select(-Date,-Time, -Time_zone)%>%
  separate(Summary, into = c("Var1", "Var2", "Var3","Var4","Var5","Var6"), sep = " ", fill = "right")%>%
  unite(Var1,Var1, Var2,Var3, sep="-")%>%
  unite(Var5, Var5, Var6, sep=" ")%>%
  mutate(Var1=gsub("-19","-", Var1))%>%   #Remove 19 before the year
  mutate(Var1 = ifelse(grepl("^[1-9]-", Var1), paste0("0", Var1), Var1))%>%
  rename(Date=Var1, Time=Var4, Time_zone=Var5)%>%
  mutate(Time_zone=gsub("NA","",Time_zone))

index_problematic <- which(nchar(Df_cleaning$Date) != 9) #Create the index of problematic dates

Df_cleaning$Date[index_problematic]<-Problematic_date$Date #Import corrected problematic dates

Df_cleaning$Time[index_problematic]<-Problematic_date$Time

Df_cleaning$Time_zone[index_problematic]<-Problematic_date$Time_zone

Problematic_date2<-Df_cleaning[nchar(Df_cleaning$Date) != 9, ]

error<-which(Df_cleaning$Summary =="Wed Dec 14 17:04:50 1994 CST") #Match error in Scraping

Df_cleaning[error,]<-Df_cleaning[error,]%>% #Solve error
  mutate(Date="14-Dec-94")%>% #Replace data
  mutate(Time_zone="CST")

error<-which(Df_cleaning$Summary =="Tue Jul 25 14:48:21 1995") #Match error in Scraping

Df_cleaning[error,]<-Df_cleaning[error,]%>% #Solve error
  mutate(Date="25-Jul-1995")%>% #Replace data
  mutate(Time_zone="")

Df_cleaning<-Df_cleaning%>%
  mutate(Time = ifelse(grepl("^\\d{2}:\\d{2}$", Time), paste0(Time, ":00"), Time))

Problematic_time<-Df_cleaning%>%   #Other problematics date, time will be solved at the end of the process.
  mutate(Time = str_trim(Time))%>%
  filter(!grepl("\\d", Time))%>%
  filter(Time!="")

#Creation of Directories

Directories<-Df_cleaning #Copy the Dataframe 

#Creating URLs of the messages

base<- c("http://1997.webhistory.org/www.lists/www-talk.1991/", 
         "http://1997.webhistory.org/www.lists/www-talk.1992/", 
         "http://1997.webhistory.org/www.lists/www-talk.1993q1/",
         "http://1997.webhistory.org/www.lists/www-talk.1993q2/",
         "http://1997.webhistory.org/www.lists/www-talk.1993q3/",
         "http://1997.webhistory.org/www.lists/www-talk.1993q4/",
         "http://1997.webhistory.org/www.lists/www-talk.1994q1/",
         "http://1997.webhistory.org/www.lists/www-talk.1994q2/",
         "http://1997.webhistory.org/www.lists/www-talk.1994q3/",
         "http://1997.webhistory.org/www.lists/www-talk.1994q4/",
         "http://1997.webhistory.org/www.lists/www-talk.1995q1/",
         "http://1997.webhistory.org/www.lists/www-talk.1995q2/",
         "http://1997.webhistory.org/www.lists/www-talk.1995q3/",
         "http://1997.webhistory.org/www.lists/www-talk.1995q4/")

URL_list <- list()   # Lista vuota per memorizzare gli URL completi

for (i in 1:14) {    # Ciclo per estrarre e creare gli URL

  testo_b <- data.frame(regmatches(HTML_df[i], gregexpr("a href=(.*?)>", HTML_df[i])))
  testo_b <- testo_b[-(1:4), ]   # Rimuovi gli header
  testo_b <- head(testo_b, -5)    # Rimuovi i footer
  testo_b <- gsub("a href=", "", testo_b)  # Imposta l'inizio del link
  testo_b <- gsub(">", "", testo_b)  # Imposta la fine del link
  testo_b <- as.data.frame(testo_b)  # Converte in data frame
  
  temp <- data.frame(testo_b) %>% 
    mutate(Url = paste0(base[i], testo_b)) %>%  # Combina base URL con link
    mutate(Url = gsub('"', "", Url))  # Rimuovi eventuali virgolette
  
  # Salva il risultato nella lista degli URL completi URL_list
  URL_list[[i]] <- temp
}

URL_df<-do.call(rbind, URL_list) #Convert in a dataframe

#Merge URLs in the directories

Directories<-Directories%>% 
  mutate(Url=URL_df$Url)

#Begginning of the Scraping

Metadata <- Directories #Create a copy of the Directories

URL<- Metadata$Url[-4483] # Create a vector of links excluding the problematic link

Time0<-Sys.time()
Time0format<-format(Time0, "%H:%M:%S")   

message("Beginning of the loop: ", Time0format)

List_Text <- list() # Creation of an empty list for storing the forthcoming results

for (i in 1:10558) {  # Select quantity of links
  
  Test <- read_html(URL[i]) # Read the HTML 
  
  Body<-as.character(Test) # Convert the HTML in Character
  
  Cleaned <- sub(".*<!-- body=\"start\" -->(.*)<!-- body=\"end\" -->.*", "\\1", Body) # Select the content of the messages
  
  Cleaned <- str_replace_all(Cleaned, "<[^>]+>", "") # Remove HTML tags
  
  Cleaned <- gsub("\n", " ", Cleaned) # Remove \n tag
  
  List_Text[[i]] <- Cleaned # Add the message to the list
}

List_Loop<-List_Text # Copy the list with the Scraping

Time1<-Sys.time()
Time1format<-format(Time1, "%H:%M:%S")  

Exc.time<- Time1-Time0

message("Beginning of the loop: ", Time0format," - End of the lopp: ", Time1format)#This message will show you the times.
print(Exc.time)

Sys.sleep(.5) #The system stop for 0.5s

beep(2) #Produce a beep when the main loop end

Text_df<- data.frame(Scraping = unlist(List_Loop)) #Convert the list in a dataframe

Data <- Text_df # Create a copy of the messages (DATA) 

Temporary_df<-Metadata[-4483,] #Remove metadata of the missing link

Temporary_df <- cbind(Temporary_df, Data) # Merge Data and Metadata.

#Scrape problematic link
Missing_Link <- c("http://1997.webhistory.org/www.lists/www-talk.1994q1/0806.html") 

req <- request(Missing_Link) # Send a request to the URL to retrieve its content

req <- req %>% 
  req_perform() %>%     # Execute the HTTP request
  resp_body_string()    # Extract the body of the response as a string


req <- sub(".*<!-- body=\"start\" -->(.*)<!-- body=\"end\" -->.*", "\\1", req) # Select the content of the messages

Cleaned <- str_replace_all(req, "<[^>]+>", "") # Remove HTML tags

Cleaned <- gsub("\n", " ", Cleaned) # Remove \n characters

Cleaned <- gsub("\\t", "", Cleaned) # Remove \t characters

Cleaned <- as.character(Cleaned) # Convert to character type if necessary

Cleaned <- gsub('\\\\', "", Cleaned) # Remove \\

Cleaned <- gsub('"', '', Cleaned) # Remove "

Missing_Link <-Cleaned #Store the cleaned content of missing link

Missing_Metadata<- Metadata[4483,] #Select missing link metadata

Missing_Metadata <- cbind(Metadata[4483,], Missing_Link) #Merge missing link's data and metadata

Missing_Metadata <- Missing_Metadata %>%
  rename(Scraping = Missing_Link) #Rename column in Scraping

#Merge missing link scraping and temporary scraping

Scraping_df_top <- Temporary_df[1:4482, ]    # Separate temporary before 4483
Scraping_df_bottom <- Temporary_df[4483:nrow(Temporary_df), ]  # Separate temporary after 4483 

Scraping_df <- rbind(Scraping_df_top, Missing_Metadata, Scraping_df_bottom) #Merge missing link


Scraping_df <- Scraping_df %>%
  mutate(Scraping = gsub("&gt;", " > ", Scraping))%>% #Remove exceeding HTML tag in the Scraping and replace with corresponding symbol
  mutate(Scraping = gsub("&lt;", " < ", Scraping))%>% 
  mutate(File_name = gsub("http://1997.webhistory.org/www.lists/", "", Url))%>% #Create a column with an univocal file name based on URL
  mutate(File_name = gsub("/", ".", File_name))%>% #Remove special characters not allowed by Windows for saving
  select(File_name, Authors, Title, Date, Time, Time_zone, Scraping, Url, everything())

rm(Scraping_df_top) #Remove useless dataframe
rm(Scraping_df_bottom) #Remove useless dataframe

#Solve Problematic time and dates

Problematic_time<-Scraping_df%>%  #Find and solve problematic time
  mutate(Time = str_trim(Time))%>% #Remove space
  filter(!grepl("\\d", Time))%>% #Find characters in Time
  filter(Time!="")%>% #Select non empty file
  mutate(Summary="Sun, 6 Mar 1994 17:15:34 --100",  ,#Qualitative correction
         Title="Insecure WWW Access Authorization Protocol?", #Qualitative correction
         Date="1994-03-06",#Qualitative correction
         Time="17:15:34",#Qualitative correction
         Time_zone="-100")%>% #Qualitative correction
  select(File_name, Authors, Title, Date, Time, Time_zone, Scraping, Url, everything())#Arrange columns

error<-which(Scraping_df$File_name == Problematic_time$File_name) #Match error in Scraping

Scraping_df[error,]<-Problematic_time #Solve error. ATTENTIOn!!!! This code will create other errors

Problematic_time<-Scraping_df%>%     #Find and solve problematic time
  mutate(Time = str_trim(Time))%>%  #Remove space
  filter(!grepl("\\d", Time))%>%     #Find characters in Time
  mutate(Date=dmy(Date))            #Convert in ISO

error<-which(Scraping_df$File_name =="www-talk.1994q4.0876.html") #Match error in Scraping

Scraping_df[error,]<-Scraping_df[error,]%>% #Solve error
  mutate(Time=Time_zone)%>% #Replace data
  mutate(Time_zone="+0100")  #Replace data

error<-which(Scraping_df$File_name =="www-talk.1994q4.1025.html") #Match error in Scraping

Scraping_df[error,]<-Scraping_df[error,]%>% #Solve error
  mutate(Time=Time_zone)%>%  #Replace data
  mutate(Time_zone="+0100")  #Replace data

error<-which(Scraping_df$File_name =="www-talk.1994q4.0726.html") #Match error in Scraping

Scraping_df[error,]<-Scraping_df[error,]%>% #Solve error
  mutate(Time=Time_zone)%>%  #Replace data
  mutate(Time_zone="+0100")  #Replace data

Problematic_time<-Scraping_df%>% #Solve error
  mutate(Time = str_trim(Time))%>%  #Replace data
  filter(!grepl("\\d", Date))  #Replace data

error<-which(Scraping_df$File_name == "www-talk.1994q1.0805.html")

Scraping_df[error,]<-Scraping_df[error,]%>% #Solve error
  mutate(Date="06-Mar-1994")

Scraping_df$Date<-dmy(Scraping_df$Date)

View(Scraping_df)

emptyLine<-Scraping_df[is.na(Scraping_df$Scraping) |  Scraping_df$Scraping =="", ] #20 empty observation in Scraping (Qualitatively verified: not error404)

Missing_Date<-Scraping_df%>% #Solve error
  mutate(Time = str_trim(Time))%>%  #Replace data
  filter(!grepl("\\d", Date))
####################################3

Na_authors<-Scraping_df%>%
  filter(Authors=="")

error<-which(Scraping_df$File_name == "www-talk.1992.0092.html")

Scraping_df[error,]<-Scraping_df[error,]%>% #Solve error
  mutate(Authors="mitra@pandora.sf.ca.us")

error<-which(Scraping_df$File_name == "www-talk.1993q4.0478.html")

Scraping_df[error,]<-Scraping_df[error,]%>% #Solve error
  mutate(Authors="/S=muenkel/OU=tnt/@uni-hannover.de")

error<-which(Scraping_df$File_name == "www-talk.1993q4.0256.html")

Scraping_df[error,]<-Scraping_df[error,]%>% #Solve error
  mutate(Authors="/S=muenkel/OU=tnt/@uni-hannover.de")

error<-which(Scraping_df$File_name == "www-talk.1993q4.0257.html")

Scraping_df[error,]<-Scraping_df[error,]%>% #Solve error
  mutate(Authors="/S=muenkel/OU=tnt/@uni-hannover.de")

error<-which(Scraping_df$File_name == "www-talk.1994q1.1052.html")

Scraping_df[error,]<-Scraping_df[error,]%>% #Solve error
  mutate(Authors="jac15@po.cwru.edu")

error<-which(Scraping_df$File_name == "www-talk.1994q2.1077.html")

Scraping_df[error,]<-Scraping_df[error,]%>% #Solve error
  mutate(Authors="young@map5621.fams.af.mil")

#Saving as .rds
saveRDS(Scraping_df, file = "WWWTALK_df.rds") #Saving as .rds

# Excel to store Directories

Directories<-Directories%>% 
  mutate(File_name=Scraping_df$File_name)%>% #Import File_na,e
  select(File_name, everything()) #Arrange variables

write.xlsx(Directories, file = "Directories_WWWTALK.xlsx") #Create an Excel of the Directories

#Saving as txt in a subfolder
output_dir <- "WWWTALK_Text" #Set the subfolder's directory

dir.create(output_dir) # Create the subfolder's directory

for (i in 1:10559) { # Loop for saving file with file name (final part of the URL, without "/") 
  file_name <- file.path(output_dir, paste0(Scraping_df$File_name[i], ".txt")) #Create file name
  writeLines(Scraping_df$Scraping[i], file_name) #Save file
}

Sys.sleep(.5)
beep(1)

Timeline<- Scraping_df %>%
  mutate(Date_Ym = format(Date, "%Y-%m"))%>%  # New column and date format
  group_by(Date_Ym) %>%                        # Group by Date
  summarise(Tot_Month = n())                   #Monthtly tot


ggplot(Timeline, aes(x = Date_Ym, y = Tot_Month)) +             # Create a timeline
  geom_bar(stat = "identity", width = 0.65) +                    # Choose bars with adjusted width
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +    # Custom axis
  geom_text(aes(label = Tot_Month), vjust = -0.3, size = 2.5) + # Add values' label
  xlab("Timeline (Y-m)") +                                       # Title x axis
  ylab("Quantity of messages") +                                 # Title y axis
  ggtitle("Message distribution over time") +                    # Title graph
  scale_x_discrete(limits = Timeline$Date_Ym) # Set limits for x axis

message("End of the code: ", Sys.time()) #Send a message at the end of the process
beep(1)#Produce a sound at the end of the process



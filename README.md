# WWW.List_Scraper 1997.webhistory.org . 

These scrapers are independent projects developed to extract and create a dataframe from the WWW mailing lists hosted by The World Wide Web History Project at http://1997.webhistory.org/www.lists/. These project **is not affiliated with or endorsed** by The World Wide Web History Project or Arcady Press.

All rights to the content extracted from this site, including messages and media, are owned by **Copyright © 1996-2003 The World Wide Web History Project and Arcady Press**. For more legal information, please refer to: http://1997.webhistory.org/legal.html.

This scrapers are intended for informational and non-commercial purposes only, in full compliance with the copyright terms of the original site. The scrapers generate dataframes containing both the messages and their metadata. Additionally, they create Excel files to store the metadata and folders with the messages saved in .txt format.

Please note:

  1) The data and metadata extracted by this scraper are provided "as is," with no warranties of any kind, including but not limited to implied warranties of merchantability, fitness for a particular purpose, or non-infringement.

  2) Neither The World Wide Web History Project nor the developer of this scraper is liable for any special, incidental, indirect, or consequential damages resulting from the use of the data or this scraper, including but not limited to loss of data or profits.

  3) Neither the production, use, nor modifications of these scrapers imply any endorsement by The World Wide Web History Project of these tools, their developers, or any associated products.

# What does the Scraper do?
This repository contains a set of scrapers designed to create a dataframe and make the exploration of mailing lists easier, as the original website offers limited search functionality and lacks well-structured dataframes for both metadata and messages.

The scraper starts from the mailing list directories sorted by subject, as this option provides the most metadata. It starts by creating a dataframe with key metadata for each message, including Author, Title, Date, Time, Time Zone, and URL. Dates are converted from the RFC 5322 format to the ISO 8601 standard, with the Date, Time, and Time Zone split into separate columns to facilitate data analysis. The original RFC 5322-formatted dates are preserved in the "Summary" column for reference.

In some cases, manual corrections were applied to Date, Time, and Time Zone metadata due to formatting errors in the original data. After constructing the directories' dataframe, the scraper downloads the URLs containing the messages, removes the headers and footers (which often include navigation options and metadata), and finally saves the message content into the dataframe.

Both directory and message scraping involve conversion from HTML to string format, so some special characters might not have been fully reconverted during the process. A message from WWWTalk could not be converted and had to be imported manually. The problematic message is saved in the .txt file called 'missing_link' and will be automatically imported in the scraper.

The table below shows the total number of messages and indicates how many are empty or lack a date. In WWWVRML, many messages are missing because the URLs return a 404 error. In other mailing lists, the URLs are accessible, but the message has no content.

![image](https://github.com/user-attachments/assets/63aa633e-459d-48ea-8110-305ec2b435b9)



## Reference
Please use the following references when citing or using these scrapers:

Fomasi, M. (2024). WWWTalk_Scraper_1997.webhistory.org (Version 1.0) [R; Windows (64x)]. https://github.com/MartinFomasi/WWW.List_Scraper_1997.webhistory.org

Fomasi, M. (2024). WWWHTML_Scraper_1997.webhistory.org (Version 1.0) [R; Windows (64x)]. https://github.com/MartinFomasi/WWW.List_Scraper_1997.webhistory.org

Fomasi, M. (2024). WWWVRML_Scraper_1997.webhistory.org (Version 1.0) [R; Windows (64x)]. https://github.com/MartinFomasi/WWW.List_Scraper_1997.webhistory.org

Fomasi, M. (2024). WWWliterature_style_courseware_Scraper_1997.webhistory.org (Version 1.0) [R; Windows (64x)]. https://github.com/MartinFomasi/WWW.List_Scraper_1997.webhistory.org




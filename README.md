# WWW.List_Scraper 1997.webhistory.org (Beta). 

These scrapers are independent projects developed to extract and create a dataframe from the WWW mailing lists hosted by The World Wide Web History Project at http://1997.webhistory.org/www.lists/. These project **is not affiliated with or endorsed** by The World Wide Web History Project or Arcady Press.

All rights to the content extracted from this site, including messages and media, are owned by **Copyright © 1996-2003 The World Wide Web History Project and Arcady Press**. For more legal information, please refer to: http://1997.webhistory.org/legal.html.

This scrapers are intended for informational and non-commercial purposes only, in full compliance with the copyright terms of the original site. The scrapers generate dataframes containing both the messages and their metadata. Additionally, they create Excel files to store the metadata and folders with the messages saved in .txt format.

Please note:

  1) The data and metadata extracted by this scraper are provided "as is," with no warranties of any kind, including but not limited to implied warranties of merchantability, fitness for a particular purpose, or non-infringement.

  2) Neither The World Wide Web History Project nor the developer of this scraper is liable for any special, incidental, indirect, or consequential damages resulting from the use of the data or this scraper, including but not limited to loss of data or profits.

  3) Neither the production, use, nor modifications of these scrapers imply any endorsement by The World Wide Web History Project of these tools, their developers, or any associated products.

## What does the Scraper do?
This repository contains a set of scrapers designed to create a dataframe, making mailing list exploration easier. The original website offers limited search functionality and lacks well-structured dataframes for both metadata and message content.

1. **Meadata Extraction**: The scraper starts by gathering metadata from mailing list directories sorted by subject, as this structure provides the most comprehensive metadata. The extracted metadata includes:

  * Author
  * Title
  * Date (converted to ISO 8601 format)
  * Time and Time Zone (in ISO 8601 format)
  * URL

Additionally, the original date format (RFC 5322) is preserved in a “Summary” column for reference.

2. **Data Standardization**
   
  * Date Conversion: Dates are converted from RFC 5322 to ISO 8601 format for easier sorting and analysis.
  * Column Splitting: Date, Time, and Time Zone are split into separate columns to support time-based filtering and analysis.
  * Manual Corrections: Some entries required manual corrections due to inconsistent or erroneous formatting in the original data.

3. **Message Content Scraping**

  * Content Retrieval: The scraper accesses each URL linked to a message and retrieves the message body.
  * Header and Footer Removal: To focus on the core message content, headers and footers (which typically contain navigation and additional metadata) are removed.
  * Plain Text Storage: The message text is saved into the dataframe.
  
5.  **HTML to Text Conversion**

  * Both metadata and message content are parsed from HTML to plain text. Special characters may not have fully converted, so minor encoding inconsistencies might be present.

6. **Handling Missing or Problematic Data**
   
  * A specific message from WWWTalk could not be automatically scraped and was imported manually. This message is saved in a .txt file named missing_link.txt and is automatically imported by the scraper.
  * Empty Messages and 404 Errors: Some messages, especially in WWWVRML, have links that return a 404 error. In other cases, accessible URLs lead to empty message content. These cases are documented in the   summary table below.

![image](https://github.com/user-attachments/assets/63aa633e-459d-48ea-8110-305ec2b435b9)



## Reference
Please use the following references when citing or using these scrapers:

Fomasi, M. (2024). WWWTalk_Scraper_1997.webhistory.org (Version 1.0) [R; Windows (64x)]. https://github.com/MartinFomasi/WWW.List_Scraper_1997.webhistory.org

Fomasi, M. (2024). WWWHTML_Scraper_1997.webhistory.org (Version 1.0) [R; Windows (64x)]. https://github.com/MartinFomasi/WWW.List_Scraper_1997.webhistory.org

Fomasi, M. (2024). WWWVRML_Scraper_1997.webhistory.org (Version 1.0) [R; Windows (64x)]. https://github.com/MartinFomasi/WWW.List_Scraper_1997.webhistory.org

Fomasi, M. (2024). WWWliterature_style_courseware_Scraper_1997.webhistory.org (Version 1.0) [R; Windows (64x)]. https://github.com/MartinFomasi/WWW.List_Scraper_1997.webhistory.org




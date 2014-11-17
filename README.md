tagInput_new
============

tagInput

Effect:
![ScreenShot](https://raw.github.com/realzzz/tagInput_new/master/tag1.gif)
![ScreenShot](https://raw.github.com/realzzz/tagInput_new/master/tag2.gif)
![ScreenShot](https://raw.github.com/realzzz/tagInput_new/master/tag3.gif)


This is a iOS tag input/list view like below (as commonly seen on most of the websites):

 ------------------------------------
  (tag1 x) (tag2 x) (tag3 x) [ input]
 ------------------------------------
 
 You may use this by putting the tagInputView into your screen. 
 
 It will start empty
 
 ------------------------------------
 
 ------------------------------------
 
 User can tap and start input, once input finishes (end or input encounter space), it will become
 
 ------------------------------------
 (inputTag x) [                     ]
 ------------------------------------
 
 User can continue to enter new tags and scroll betwen tag.
 
 User can remove the tags by click the x in the tag.
 
 After user finishes input, you may use the - (NSArray *) currentTags; to get all the tags.
 
 
 - Check out more on example project

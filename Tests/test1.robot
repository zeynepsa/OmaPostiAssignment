*** Settings ***
Library  SeleniumLibrary

Test Setup    Login Omaposti
Test Teardown    close all browsers
Suite Teardown    close all browsers

*** Test Cases ***
TC 1,2,3 Validate Filters
    Verify Filter Function    Lasku
    Verify Filter Function    Kirje
    Verify Filter Function    Lähety

TC 4,9 Validate Archive
    Verify Archive Function

TC 5,6 Verify Track Item
    Adding Track Number
    Delete Item

TC 7 Adding An Invoice
    Adding Lasku


TC 8 Bulked Edit function

    Bulked Edit

TC 10 Selecting nearest pick up point
    Finding Nearest Pick Up Point


*** Keywords ***
Click Element When Visible
 #this click method runs when elements visible. But still in some cases I need to add sleep manually.
    [Arguments]   ${argumen_element}
    wait until element is visible     ${argumen_element}    10
    Click Element    ${argumen_element}
     
Login Omaposti
    [Documentation]    this keyword handles login function
       open browser  https://www.posti.fi/fi  chrome
       Click Element When Visible   //*[@class='onetrust-close-btn-handler onetrust-close-btn-ui banner-close-button ot-close-icon']
       Click Element When Visible  //*[@class='sc-znx61v-0 jQPfEm sc-15k4i7n-5 sc-15k4i7n-9 bmnSTH']
       Click Element When Visible  (//*[@class='sc-rujq8s-0 czoFyo sc-1iig7y8-2 excKfP'])[1]
       input text  id:username  alokmanhekim@gmail.com
       input text  id: password  Lockman23p
       Click Element When Visible  id: posti_login_btn



Verify Filter Function
    [Documentation]  this keyword handles Test Case 1,2 and 3
    [Arguments]   ${argumen_filter}
    Click Element When Visible  //*[@class='omaposti-core__sc-j0wpq0-2 gnVglU']
    Click Element When Visible  //*[@class='omaposti-core__sc-j0wpq0-2 gnVglU']/descendant::*[contains(text(),'${argumen_filter}')]
    ${item_count}    get element count     //*[@class='sc-rn2brr-0 omaposti-core__sc-16q02q3-9 imQvWl']
    FOR  ${item}   IN RANGE    1    (${item_count})+1
        ${post_type_of_item}    get text    (//*[@class='sc-rn2brr-0 omaposti-core__sc-16q02q3-9 imQvWl'])[${item}]
        should be true    "${argumen_filter}" in "${post_type_of_item}"
    END

Verify Archive Function
    [Documentation]  this keyword handles Test Case 4 and 9
    Sleep    3
    ${item_count}    get element count     //*[@class='sc-rn2brr-0 omaposti-core__sc-16q02q3-9 imQvWl']
    log to console    Selected ${item_count} item
    ${random_item}    evaluate     random.randint(1,${item_count})
    ${post_name}    get text    (//*[@class='omaposti-core__sc-16q02q3-10 bkwIBg'])[${random_item}]
    ${post_time}    get element attribute    ((//*[@class='sc-rn2brr-0 omaposti-core__sc-16q02q3-9 gwobEq'])/..//following-sibling::time)[${random_item}]     datetime
    ${post_type}    get text    (//*[@class='sc-rn2brr-0 omaposti-core__sc-16q02q3-9 imQvWl'])[${random_item}]
    log to console    ${post_name} \n ${post_time} \n ${post_type}
    Click Element When Visible    (//*[@class='omaposti-core__sc-16q02q3-0 obzuG'])[${random_item}]
    Click Element When Visible    messageOptionsMenuButton
    sleep    2
    Click Element When Visible    //*[contains(text(),'Arkistoi')]
    sleep    2
    Click Element When Visible   id:navMenuToggle
    sleep    2
    Click Element When Visible  id: label-mainMenuArchive
    sleep    3
    page should contain element     (//*[@class='omaposti-core__sc-16q02q3-10 bkwIBg'])[contains(text(),'${post_name}')]
    page should contain element    //time[@datetime='${post_time}']
    page should contain element     (//*[@class='sc-rn2brr-0 omaposti-core__sc-16q02q3-9 imQvWl'])[contains(text(),'${post_type}')]
    sleep    3
    Click Element When Visible    (//*[@class='omaposti-core__sc-16q02q3-10 bkwIBg'])[contains(text(),'${post_name}')]
    sleep    2
    Click Element When Visible    messageOptionsMenuButton
    sleep    2
    Click Element When Visible    //*[contains(text(),'Palauta')]
    sleep    2
    Click Element When Visible   id:navMenuToggle
    sleep    2
    Click Element When Visible  id: label-mainMenuInbox
    sleep    3
    page should contain element     (//*[@class='omaposti-core__sc-16q02q3-10 bkwIBg'])[contains(text(),'${post_name}')]
    page should contain element    //time[@datetime='${post_time}']
    page should contain element     (//*[@class='sc-rn2brr-0 omaposti-core__sc-16q02q3-9 imQvWl'])[contains(text(),'${post_type}')]
    log to console   \n Randomly selected item \n ${post_name} \n ${post_time} \n ${post_type} \n verified that archived and send bact to inbox


Adding Track Number
    [Documentation]  this keyword handles Test Case 5
    Click Element When Visible  (//*[@class='sc-y6ox3a-1 HumVX'])[1]
    input text  id: add-parcel-tracking-code  JJFI234567890
    Click Element When Visible  (//*[@class='sc-y6ox3a-1 kBuvGv'])
    Click Element When Visible  id: JJFI234567890_c6ef0c56-7aa2-40b6-b2ec-79c0d21735b8
    page should contain element     (//*[@class='omaposti-core__sc-16q02q3-10 bkwIBg'])[contains(text(),'JJFI234567890')]

Delete Item
    [Documentation]  this keyword handles Test Case 6
    ...    note: just deleted previous tracing item beacuse of avoid personal information lost
    Click Element When Visible    (//*[@class='omaposti-core__sc-16q02q3-10 bkwIBg'])[contains(text(),'JJFI234567890')]
    Click Element When Visible    //*[@id='options-button']
    Click Element When Visible    //*[contains(text(),'Poista')]
    Click Element When Visible    (//*[@class='sc-y6ox3a-1 lgyvXY'])[2]
    Sleep    5
    page should not contain element     (//*[@class='omaposti-core__sc-16q02q3-10 bkwIBg'])[contains(text(),'JJFI234567890')]

Adding Lasku
 #veriyied that while creating invoice\lasku all needed elements are present. I can't make further testing because application didn't accepted dummy variables.
    [Documentation]    this keyword handles Test Case 7
    Click Element When Visible  (//*[@class='sc-y6ox3a-1 HumVX'])[3]
    Sleep    5
    page should contain    Lisää uusi lasku
    page should contain element    add_invoice_account_number
    page should contain element    add_invoice_recipient
    page should contain element    add_invoice_reference_number
    page should contain element    add_invoice_remittance_info
    page should contain element    add_invoice_remittance_info
    page should contain element    add_invoice_amount
    page should contain element    (//*[@class='sc-y6ox3a-2 eEuSbA'])

Bulked Edit
     [Documentation]   this keyword handles Test Case 8
      # I could not make further testing because of personal information might be lost.
    Click Element When Visible  feedHeaderEditButton
    Sleep    5
     #${item_count}    get element count     //*[@class='sc-rn2brr-0 omaposti-core__sc-16q02q3-9 imQvWl']
     #${random_item}    evaluate     random.randint(1,${item_count})
    # Click Element When Visible     (//*[@class='sc-rn2brr-0 omaposti-core__sc-16q02q3-9 imQvWl'])[${random_item}]

    Click Element When Visible    (//*[@class='sc-rn2brr-0 omaposti-core__sc-16q02q3-9 imQvWl'])[1]
    Click Element When Visible    (//*[@class='sc-rn2brr-0 omaposti-core__sc-16q02q3-9 imQvWl'])[2]
    Sleep    5
    page should contain element    (//*[@class='omaposti-core__sc-7049j6-1 kYSuWe'])/descendant::*[contains(text(),'Poista')]
    page should contain element    (//*[@class='omaposti-core__sc-7049j6-1 kYSuWe'])/descendant::*[contains(text(),'Arkistoi')]
    page should contain element    (//*[@class='omaposti-core__sc-7049j6-1 kYSuWe'])/descendant::*[contains(text(),'Peruuta')]
    Click Element When Visible     (//*[@class='omaposti-core__sc-7049j6-1 kYSuWe'])/descendant::*[contains(text(),'Peruuta')]

Finding Nearest Pick Up Point
     [Documentation]   this keyword handles Test Case 10
    Sleep    3
    Click Element When Visible    id:navMenuToggle
    Sleep    3
    Click Element When Visible    label-mainMenuSettings
     Sleep    3
    Click Element When Visible    id: label-lowerMenuSettingsMyPickUpPoint
     Sleep    3
    Click Element When Visible     (//*[@class='sc-y6ox3a-1 HumVX'])
    Sleep    3
    input text                    (//*[@class='omaposti-core__sc-1ttb7cu-4 jrxcrP'])    00240
    Sleep    3
    ${nearest_address}    get text  (//*[@class='omaposti-core__sc-dxqia7-3 iAmsVY'])[1]
    Click Element When Visible     (//*[@class='omaposti-core__sc-dxqia7-3 iAmsVY'])[1]
    Sleep    3
    page should contain element    (//*[@class='omaposti-core__sc-1mso6jf-13 hyxVbW'])



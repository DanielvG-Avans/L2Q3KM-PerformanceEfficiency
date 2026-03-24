WWW 2012 – Session: Mobile Web Performance April 16–20, 2012, Lyon, France
|     |           |              | Who    | Killed  |        | My Battery: |     |             |        |          |     |     |     |
| --- | --------- | ------------ | ------ | ------- | ------ | ----------- | --- | ----------- | ------ | -------- | --- | --- | --- |
|     | Analyzing |              | Mobile | Browser |        | Energy      |     | Consumption |        |          |     |     |     |
|     | Narendran | Thiagarajan† |        |         | Gaurav | Aggarwal†   |     |             | Angela | Nicoara* |     |     |     |
naren@cs.stanford.edu agaurav@cs.stanford.edu angela.nicoara@telekom.com
|     |     |     | Dan | Boneh† |     | Jatinder | Pal Singh‡ |     |     |     |     |     |     |
| --- | --- | --- | --- | ------ | --- | -------- | ---------- | --- | --- | --- | --- | --- | --- |
dabo@cs.stanford.edu
jatinder@stanford.edu
†DepartmentofComputerScience,StanfordUniversity,CA
*DeutscheTelekomR&DLaboratoriesUSA,LosAltos,CA
‡DepartmentofElectricalEngineering,StanfordUniversity,CA
ABSTRACT sitesarepoorlyoptimizedforenergyuseandrenderingtheminthe
|     |     |     |     |     |     | browser takes | more | power | than necessary. | Partly | this | is due | to a |
| --- | --- | --- | --- | --- | --- | ------------- | ---- | ----- | --------------- | ------ | ---- | ------ | ---- |
Despitethegrowingpopularityofmobilewebbrowsing,theenergy
consumedbyaphonebrowserwhilesurfingthewebispoorlyun- weakunderstandingofthebrowser’senergyuse.
derstood. We present an infrastructure for measuring the precise In this paper we set out to analyze the energy consumption of
theAndroidbrowseratpopularwebsitessuchasFacebook,Ama-
| energy | used by a mobile | browser | to render | web pages. | We then |          |              |     |              |       |          |     |        |
| ------ | ---------------- | ------- | --------- | ---------- | ------- | -------- | ------------ | --- | ------------ | ----- | -------- | --- | ------ |
|        |                  |         |           |            |         | zon, and | many others. | Our | experimental | setup | includes | a   | multi- |
measuretheenergyneededtorenderfinancial,e-commerce,email,
|           |                 |            |        |           |            | meter hooked | up  | to the phone | battery | that measures |     | the phone’s |     |
| --------- | --------------- | ---------- | ------ | --------- | ---------- | ------------ | --- | ------------ | ------- | ------------- | --- | ----------- | --- |
| blogging, | news and social | networking | sites. | Our tools | are suffi- |              |     |              |         |               |     |             |     |
energyconsumptionasthephoneloadsandrenderswebpages.We
cientlyprecisetomeasuretheenergyneededtorenderindividual
patchedthedefaultAndroidbrowsertohelpusmeasuretheprecise
webelements,suchascascadestylesheets(CSS),Javascript,im-
energyusedfromthemomentthebrowserbeginsnavigatingtothe
| ages,andplug-inobjects. |     | Ourresultsshowthatforpopularsites, |     |     |     |     |     |     |     |     |     |     |     |
| ----------------------- | --- | ---------------------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
desiredwebsiteuntilthepageisfullyrendered.Thepatchalsolets
downloadingandparsingcascadestylesheetsandJavascriptcon-
usmeasuretheexactenergyneededtorenderapageexcludingthe
sumesasignificantfractionofthetotalenergyneededtorenderthe
|     |     |     |     |     |     | energyconsumedbytheradio. |     |     | Oursetupisdescribedindetailin |     |     |     |     |
| --- | --- | --- | --- | --- | --- | ------------------------- | --- | --- | ----------------------------- | --- | --- | --- | --- |
page. Usingthedatawecollectedwemakeconcreterecommen-
dationsonhowtodesignwebpagessoastominimizetheenergy Section2.Inthatsectionwealsodescribetheenergymodelforthe
neededtorenderthepage.Asanexample,bymodifyingscriptson phone’sradiowhichissimilartomodelspresentedin[18,10].
|     |     |     |     |     |     | Using | our experimental |     | setup we | measured | the energy | needed |     |
| --- | --- | --- | --- | --- | --- | ----- | ---------------- | --- | -------- | -------- | ---------- | ------ | --- |
theWikipediamobilesitewereducedby30%theenergyneededto
torenderpopularwebsitesaswellastheenergyneededtorender
downloadandrenderWikipediapageswithnochangetotheuser
|             |                                               |     |     |     |     | individualwebelementssuchasimages, |     |     |     | Javascript, |     | andCascade |     |
| ----------- | --------------------------------------------- | --- | --- | --- | --- | ---------------------------------- | --- | --- | --- | ----------- | --- | ---------- | --- |
| experience. | Weconcludebyestimatingthepointatwhichoffload- |     |     |     |     |                                    |     |     |     |             |     |            |     |
StyleSheets(CSS).WefindthatcomplexJavascriptandCSScan
ingbrowsercomputationstoaremoteproxycansaveenergyonthe
beasexpensivetorenderasimages.Moreover,dynamicJavascript
phone.
|     |     |     |     |     |     | requests (in | the form | of XMLHttpRequest) |     |     | can greatly | increase |     |
| --- | --- | --- | --- | --- | --- | ------------ | -------- | ------------------ | --- | --- | ----------- | -------- | --- |
thecostofrenderingthepagesinceitpreventsthepagecontents
CategoriesandSubjectDescriptors
|     |     |     |     |     |     | frombeingcached. |     | Finally,weshowthatontheAndroidbrowser, |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | ---------------- | --- | -------------------------------------- | --- | --- | --- | --- | --- |
renderingJPEGimagesisconsiderablycheaperthanotherformats
| D.2 [Software]: | Software | Engineering; | D.2.11 | [Software | Engi- |     |     |     |     |     |     |     |     |
| --------------- | -------- | ------------ | ------ | --------- | ----- | --- | --- | --- | --- | --- | --- | --- | --- |
neering]:SoftwareArchitectures;D.2.8[SoftwareEngineering]: suchasGIFandPNGforcomparablesizeimages. Forexample,
Metrics—PerformanceMeasures whenwetranslateallimagesontheFacebookwebsitetoJPEGwe
obtainconsiderableenergysavings.
Usingourenergymeasurementswesuggestguidelinesforbuild-
GeneralTerms
|     |     |     |     |     |     | ing energy-efficient |     | web pages, | namely | pages | that reduce | energy |     |
| --- | --- | --- | --- | --- | --- | -------------------- | --- | ---------- | ------ | ----- | ----------- | ------ | --- |
Design,Measurement,Performance useontheclient. Forexample,byapplyingourguidelinestothe
|     |     |     |     |     |     | Wikipedia | mobile | site we | reduced | its energy | consumption |     | from |
| --- | --- | --- | --- | --- | --- | --------- | ------ | ------- | ------- | ---------- | ----------- | --- | ---- |
Keywords 35 Joules to 25 Joules, a saving of 29%. Our modification sim-
|     |     |     |     |     |     | ply changes | how | Javascript | works | on the page, | without | affecting |     |
| --- | --- | --- | --- | --- | --- | ----------- | --- | ---------- | ----- | ------------ | ------- | --------- | --- |
Mobile browser, Energy consumption, Offloading computations, theuserexperience. Themeasurementsinthispaperquantifyhow
Android
muchenergycanbesavedbyfollowingtheseguidelines.
Beyondoptimization,ourexperimentsletusestimatetheeffec-
1. INTRODUCTION
|     |     |     |     |     |     | tiveness of | offloading | browser | computations |     | to a remote |     | server. |
| --- | --- | --- | --- | --- | --- | ----------- | ---------- | ------- | ------------ | --- | ----------- | --- | ------- |
RecentstatisticsfromNetMarketShareshowthatabout3%ofall Section5givesquantitativenumbersforamodernsmartphone,the
|           |              |         |           |          |           | AndroidADP2phone[2]. |     |                                           | Wediscussrelatedandfutureworkin |     |     |     |     |
| --------- | ------------ | ------- | --------- | -------- | --------- | -------------------- | --- | ----------------------------------------- | ------------------------------- | --- | --- | --- | --- |
| worldwide | web browsing | is done | on mobile | browsers | [5]. Many |                      |     |                                           |                                 |     |     |     |     |
|           |              |         |           |          |           | Sections6and7.       |     | Topromotefurtherresearchonbuilding“green” |                                 |     |     |     |     |
popularsitesrespondedbyprovidingamobileversionoftheirsite
energyefficientwebsitesweplantoreleaseourexperimentalsetup
optimizedforasmallscreen.However,weshowthatmanymobile
andmeasurementcodeforotherstouse.
CopyrightisheldbytheInternationalWorldWideWebConferenceCom-
| mittee(IW3C2). | Distributionofthesepapersislimitedtoclassroomuse, |     |     |     |     |     |     |     |     |     |     |     |     |
| -------------- | ------------------------------------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
andpersonalusebyothers.
WWW2012,April16–20,2012,Lyon,France.
ACM978-1-4503-1229-5/12/04.
41

WWW 2012 – Session: Mobile Web Performance April 16–20, 2012, Lyon, France
Figure1:Thehardwarepowermultimeterandanopenbattery
usedformeasuringenergyconsumption
 1400
fb-full-8-nocache-3.94v.plot
 1200
|  1000 |     |     |     |     |     |     |     | Figure3:Systemarchitecture |     |     |     |     |     |     |
| ----- | --- | --- | --- | --- | --- | --- | --- | -------------------------- | --- | --- | --- | --- | --- | --- |
)Wm( rewoP
 800
|  600 |     |     |     |     |     |     | • NoCache. | Browsercacheisemptiedbeforestartingtoload |     |     |     |     |     |     |
| ---- | --- | --- | --- | --- | --- | --- | ---------- | ----------------------------------------- | --- | --- | --- | --- | --- | --- |
theURLsothatallelementsofthewebpagearefirstdown-
 400
|      |     |     |     |     |     |     | loaded                                             | from | the network | and | then | rendered | on the | phone. |
| ---- | --- | --- | --- | --- | --- | --- | -------------------------------------------------- | ---- | ----------- | --- | ---- | -------- | ------ | ------ |
|  200 |     |     |     |     |     |     | Thismodeletsusmeasurethetotalenergyusedfornavigat- |      |             |     |      |          |        |        |
ingtothepage,including3Gtransmission,parsingHTML,
 0
|  0  |  5000 |  10000 |  15000 |     |  20000 |  25000 | andrendering. |     |     |     |     |     |     |     |
| --- | ----- | ------ | ------ | --- | ------ | ------ | ------------- | --- | --- | --- | --- | --- | --- | --- |
Time (2ms units)
Figure2:SamplemultimeteroutputgraphforaFacebookpage
|     |     |     |     |     |     |     | • With | Cache. | All | elements | of the | web | page are | already |
| --- | --- | --- | --- | --- | --- | --- | ------ | ------ | --- | -------- | ------ | --- | -------- | ------- |
presentinthebrowsercachesothatthereisnoneedtousethe
2. METHODOLOGY radiotodownloadanycontent. Thismodeletsusmeasure
|     |     |     |     |     |     |     | the energy | needed |     | to parse | and render | HTML | from | cache. |
| --- | --- | --- | --- | --- | --- | --- | ---------- | ------ | --- | -------- | ---------- | ---- | ---- | ------ |
Webeginbydescribingourhardwareandsoftwaresetup.
No3Gtrafficisallowedinthismode.
2.1 HardwareSetup Oursoftwaresetupconsistsoftwocomponents: (1)aBrowser
|                 |      |           |     |            |           |     | Profiler, an | Android | application |     | we wrote, | and | (2) the | built-in |
| --------------- | ---- | --------- | --- | ---------- | --------- | --- | ------------ | ------- | ----------- | --- | --------- | --- | ------- | -------- |
| Our experiments | were | performed | on  | an Android | Developer |     |              |         |             |     |           |     |         |          |
Phone2(ADP2)[2]. Themobiledeviceis3G-enabledT-Mobile AndroidBrowser with some modifications described below. We
phonethatuses3Gand2.5GandisequippedwithanARMpro- willrefertothese asProfiler andBrowser respectively. Figure 3
cessor, 192MB/ 288MB RAM, a 2GB MicroSD card, and an illustratestheinformationflowbetweenthesecomponents.
| 802.11b/gWiFiinterface. |     | WemeasureitsbatterycapacityinSec- |     |     |     |     |                      |     |     |                                   |     |     |     |     |
| ----------------------- | --- | --------------------------------- | --- | --- | --- | --- | -------------------- | --- | --- | --------------------------------- | --- | --- | --- | --- |
|                         |     |                                   |     |     |     |     | MeasurementWorkflow. |     |     | TheProfilerprovidesasimpleuserin- |     |     |     |     |
tion2.4.
|     |     |     |     |     |     |     | terfacethattakesURLP |     |     | andnumberofiterationsnasinput. |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | -------------------- | --- | --- | ------------------------------ | --- | --- | --- | --- |
Today’smobiledevicessupportahighlevelAPIforfindingout
|     |     |     |     |     |     |     | When the | user | taps a | button | to start | profiling, | Profiler | tells |
| --- | --- | --- | --- | --- | --- | --- | -------- | ---- | ------ | ------ | -------- | ---------- | -------- | ----- |
thebatterylevel,butprovidenosupportforobtainingprecisefine-
|                |         |        |                      |     |     |         | the browser        | to load | the         | web page | P in     | NoCache   | mode.      | First, |
| -------------- | ------- | ------ | -------------------- | --- | --- | ------- | ------------------ | ------- | ----------- | -------- | -------- | --------- | ---------- | ------ |
| grained energy | use. To | obtain | precise measurements |     | we  | use the |                    |         |             |          |          |           |            |        |
|                |         |        |                      |     |     |         | Profiler instructs |         | the browser |          | to clear | its cache | by sending |        |
Agilent34410A[1]high-precisiondigitalpowermultimetershown
|     |     |     |     |     |     |     | ACTION_CLEAR_CACHE |     | intent | [4]. | Browser | responds | by  | com- |
| --- | --- | --- | --- | --- | --- | --- | ------------------ | --- | ------ | ---- | ------- | -------- | --- | ---- |
in Figure 1. The multimeter provides fine grained measurements pletely clearing its cache and sends back CACHE_CLEARED intent
| every1milliseconds,namelyasamplingrateof1kHz. |     |     |     |     |     | Asample |              |      |               |     |        |         |         |       |
| --------------------------------------------- | --- | --- | --- | --- | --- | ------- | ------------ | ---- | ------------- | --- | ------ | ------- | ------- | ----- |
|                                               |     |     |     |     |     |         | to Profiler. | Both | these intents | are | custom | intents | defined | by us |
powergraphispresentedinFigure2,wherethehighpowerinterval
|     |     |     |     |     |     |     | anddiscussedindetaillaterinthissection. |     |     |     |     | Now,Profilerasksthe |     |     |
| --- | --- | --- | --- | --- | --- | --- | --------------------------------------- | --- | --- | --- | --- | ------------------- | --- | --- |
capturesbrowseractivity.
|     |     |     |     |     |     |     | browsertoloadwebpageP |     |     | bysendingthebuilt-inACTION_VIEW |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --------------------- | --- | --- | ------------------------------- | --- | --- | --- | --- |
TheAndroidmobiledevicewillnotbootwithoutthebatteryin
intent.Oncepageloadfinishes,userpressestheBACKbuttononthe
thephone.Therefore,weleftthebatteryinsidethephoneandmea-
|     |     |     |     |     |     |     | AndroiddevicetotransfercontrolbacktoProfiler. |     |     |     |     |     | Thisprocessis |     |
| --- | --- | --- | --- | --- | --- | --- | --------------------------------------------- | --- | --- | --- | --- | --- | ------------- | --- |
suredcontinuouspowertransferredfromthebatterytothephone.
|             |                  |     |          |              |              |     | repeated n | times | and represents |     | n page | loads | of P in NoCache |     |
| ----------- | ---------------- | --- | -------- | ------------ | ------------ | --- | ---------- | ----- | -------------- | --- | ------ | ----- | --------------- | --- |
| The charger | was disconnected |     | in order | to eliminate | interference |     |            |       |                |     |        |       |                 |     |
mode.
| from the | battery charging | circuitry. | To  | measure | the energy | con- |                                            |     |     |     |     |     |     |        |
| -------- | ---------------- | ---------- | --- | ------- | ---------- | ---- | ------------------------------------------ | --- | --- | --- | --- | --- | --- | ------ |
|          |                  |            |     |         |            |      | AttheendofNoCachemode,allcomponentsofpageP |     |     |     |     |     |     | willbe |
sumption,weopenedthebatterycaseandplaceda0.1ohmresistor
presentinthebrowsercache.Now,Profilerasksthebrowsertoload
| in series | with the ground. | We measured |     | the input | voltage | to the |     |     |     |     |     |     |     |     |
| --------- | ---------------- | ----------- | --- | --------- | ------- | ------ | --- | --- | --- | --- | --- | --- | --- | --- |
P againntimesusingsamecombinationofACTION_VIEWintent
phoneandthevoltagedropontheresistorfromwhichwecalculate and BACK button as before. However, we do not clear the cache
thephone’sinstantaneouspowerconsumption.
|                   |     |     |     |     |     |     | aftereveryloadthistime. |          |      | So,thisrepresentsnpageloadsofP |          |           |               | in  |
| ----------------- | --- | --- | --- | --- | --- | --- | ----------------------- | -------- | ---- | ------------------------------ | -------- | --------- | ------------- | --- |
| 2.2 SoftwareSetup |     |     |     |     |     |     | WithCachemode.          |          |      |                                |          |           |               |     |
|                   |     |     |     |     |     |     | At the end              | of every | page | load,                          | Profiler | also logs | the following |     |
Inadditiontothehardwaresetupwealsohadtomodifythede-
informationtoafile:
| fault Android | browser. | Our modified | browser | enables | us  | to fully |     |     |     |     |     |     |     |     |
| ------------- | -------- | ------------ | ------- | ------- | --- | -------- | --- | --- | --- | --- | --- | --- | --- | --- |
loadaURLP inoneoftwomodes: 1. WiFiand3GsignalstrengthobtainedusingAndroidAPI.
42

WWW 2012 – Session: Mobile Web Performance April 16–20, 2012, Lyon, France
2. Tx/Rx bytes: Number of bytes sent and received by the cache, the browser tries to download a slightly different
browser obtained using getUidTxBytes(int uid) URL - http://www.google.com/m/gn/loc?output=
and getUidRxBytes(int uid) functions in json&text=94219. Since the value of the text parame-
android.os.NetStatclass. terisdifferentfromthecachedcopy,cachelookupfailsand
|     |     |     |     |     |     |     |     | a network | request | is issued. | As a workaround, | we identi- |
| --- | --- | --- | --- | --- | --- | --- | --- | --------- | ------- | ---------- | ---------------- | ---------- |
3. PageloadtimeandlistofURLscorrespondingtoallcompo-
fiedallsuch“changing”URLsandmodifiedbrowsercode
nentsofthepagethatweredownloaded.Thisinformationis
|     |     |     |     |     |     |     |     | to ignore | the | GET parameters | in cache lookup. | This sup- |
| --- | --- | --- | --- | --- | --- | --- | --- | --------- | --- | -------------- | ---------------- | --------- |
sentbythebrowserafterpageloadcompletes.
|     |     |     |     |     |     |     |     | pressednetworktrafficforthesepages. |     |     | [Notethatwecould |     |
| --- | --- | --- | --- | --- | --- | --- | --- | ----------------------------------- | --- | --- | ---------------- | --- |
notsimplyturnoffthe3Gradio,sincethenthepagewould
| ChangestotheAndroidBrowser. |     |     |     | Atahighlevel, |     | theAndroid |     | notrender]. |     |     |     |     |
| --------------------------- | --- | --- | --- | ------------- | --- | ---------- | --- | ----------- | --- | --- | --- | --- |
Browserconsistsofthreelayers:
1. UILayer-ThiscontainsallAndroidActivities[3]thatcom- 2. Intercept Page Load. When recording samples using multi-
prise browser chrome, user interface elements like buttons, meterasexplainedinSection2.1,thereshouldbeminimalin-
menusandcorrespondingeventhandlers. teractionwiththephonetoensureaccuratemeasurements. To
achievethis,wemodifiedthebrowsertoaskuser’spermission
2. WebKitGlue-ThiscontainsJavaclassesthatmaintaincur-
tostartloadingawebpagebydisplayingadialogandsuspend
| rent state | of the | browser | like | open tabs | and | acts as | an in- |     |     |     |     |     |
| ---------- | ------ | ------- | ---- | --------- | --- | ------- | ------ | --- | --- | --- | --- | --- |
termediarybetweentheUILayerandnativeWebKit. Itin- allbrowseractivityuntilitobtainsthepermission.Nowtotake
cludesCacheManagerclasswhichprovidesaninterfaceto measurementswecanfollowthissimpleprocess: EnterURL
store and lookup pages from a SQLite based cache. Also, tomeasureandhitloadonthebrowser. Browserwilldisplay
NetworkLoaderclassisusedtodownloadcontentfromthe thedialogandwaitforusertopress“ok”.Then,setupthemul-
network. timeterandtriggerrecordingofsamples.Lastly,hit“ok”onthe
dialogtostartloadingthewebpage.
| 3. Native | WebKit  | Layer | - This | consists | of      | the        | native |          |          |               |                         |      |
| --------- | ------- | ----- | ------ | -------- | ------- | ---------- | ------ | -------- | -------- | ------------- | ----------------------- | ---- |
| WebKit[8] | library | which | parses | and      | renders | downloaded |        |          |          |               |                         |      |
|           |         |       |        |          |         |            |        | 3. Track | metrics. | Browser keeps | a list of all component | URLs |
webpagesonthephonescreen.ItreliesonNetworkLoader
thataredownloadedoverthenetworkaspartofrenderingthe
| and CacheManager |     | classes | to  | download | different | compo- |     |     |     |     |     |     |
| ---------------- | --- | ------- | --- | -------- | --------- | ------ | --- | --- | --- | --- | --- | --- |
page. Italsotracksthetimetakentoloadtheentirewebpage.
| nentsofawebpage. |     | ThislayeralsocontainstheJavascript |     |     |     |     |     |     |     |     |     |     |
| ---------------- | --- | ---------------------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
Oncethepageloadcompletes,itsendsthislistofdownloaded
engine.
URLsandpageloadtimetoProfilerwhichlogsthemtoafile.
| To measure | the precise | energy | used | by the | browser | we  | had to |     |     |     |     |     |
| ---------- | ----------- | ------ | ---- | ------ | ------- | --- | ------ | --- | --- | --- | --- | --- |
Whenpageisbeingloadedfromcache,thislistofURLsshould
| makeafewmodificationstothedefaultAndroidbrowser. |     |     |     |     |     |     |     | beempty. |     |     |     |     |
| ------------------------------------------------ | --- | --- | --- | --- | --- | --- | --- | -------- | --- | --- | --- | --- |
1. Cachemanagement. Asdescribedearlier,weloadapagein Impact on measurements. Our modifications to the browser do
WithCacheandNoCachemodetoisolatetheenergyusedfor not change the browser’s energy profile. Clearing the cache pro-
renderingawebpagefromthatusedfortransmission. Toim- grammatically does not modify the code path for loading a web
plementthesemodeswehadtomakethefollowingchangesto page. Changes to cache everything mainly involve commenting
cachemanagementintheAndroidbrowser: out code that checks for Cache-control headers, Expiry header
|     |     |     |     |     |     |     |     | field etc. | Our other | modifications | such as, tracking | metrics and |
| --- | --- | --- | --- | --- | --- | --- | --- | ---------- | --------- | ------------- | ----------------- | ----------- |
• Cacheeverything-WithCachemodecanbeusedtomea-
stringcomparisonsduringcachelookuphavenegligibleimpacton
surerenderingenergyonlyifallcomponentsofthewebpage
browserenergyuse.
arecachedandhencethereisnoneedtodownloadanynew
|          |              |     |       |          |     |         |       | 2.3 Automation |     |     |     |     |
| -------- | ------------ | --- | ----- | -------- | --- | ------- | ----- | -------------- | --- | --- | --- | --- |
| content. | CacheManager |     | class | contains | the | browser | cache |                |     |     |     |     |
management policy. We modified this class to cache redi- The energy measurement system described in Section 2.2
rectscontainingacookieheaderandHTTPresponseswith requiressignificantuserassistanceinthemeasurementprocess.To
zerocontentlengthwhichareotherwisenotcached. Also, performalargenumberofmeasurementsweautomatedtheprocess
weignoreCache-Controlheaders,Pragma: no-cacheand byusingtheSCPIprogramminginterfaceonthemultimeter.
ExpiresheaderfieldinanyHTTPresponse.
|               |                  |     |     |           |          |     |         | Systemcomponents. |     | Ourenergymeasurementsystemconsistsof |     |     |
| ------------- | ---------------- | --- | --- | --------- | -------- | --- | ------- | ----------------- | --- | ------------------------------------ | --- | --- |
| • Clear cache | programmatically |     |     | - Browser | contains |     | a Pref- |                   |     |                                      |     |     |
thefollowingcomponents:
| erence     | option | to clear   | the cache | that           | can only | be set | man-   |           |     |     |     |     |
| ---------- | ------ | ---------- | --------- | -------------- | -------- | ------ | ------ | --------- | --- | --- | --- | --- |
| ually.     | Since  | we would   | be        | using Profiler | to       | make   | mea-   | • Server, |     |     |     |     |
| surements, | we     | introduced | a         | new Android    |          | intent | called |           |     |     |     |     |
• AndroidPhone(client),and
ACTION_CLEAR_CACHE.Asdescribedearlier,Profilerissues
• Multimeter.
thisintenttothebrowserwhichactsuponitbyclearingits
| cache. | We also | added | another | intent | CACHE_CLEARED |     | to  |     |     |     |     |     |
| ------ | ------- | ----- | ------- | ------ | ------------- | --- | --- | --- | --- | --- | --- | --- |
Figure4showshowthesecomponentsinteract.Theservercontrols
serve as a callback from the browser to Profiler to inform thephone(client)andthemultimeter,tellingitwhentostart,stop
thatcachehasbeenclearedsothatitcancontinuewiththe andsavethemeasurements. Whentheexperimentstartstheserver
nextmeasurement. communicateswithourBrowserProfilerapplicationonthephone.
• Handle “changing” URLs - During our experiments we Theserverinstructsthisapplicationtorequesttherunningphone
noticed that despite our caching mode, the browser was browsertorepeatedlyloadaspecificURL,eitherwithorwithout
| still downloading |     | content | from | the | network. | Part | of  | caching. |     |     |     |     |
| ----------------- | --- | ------- | ---- | --- | -------- | ---- | --- | -------- | --- | --- | --- | --- |
the reason was due to GET requests with varying pa- During this process the server also starts the multimeter mea-
rameters. For example, while loading www.google. surement. The server communicates with the Agilent multimeter
com, the browser downloads http://www.google.com/ using SCPI commands. Due to the limitations set by SCPI com-
m/gn/loc?output=json&text=87135andcachesthere- mands,thehighestsamplingrateachievableforthemeasurements
sult. However, when loading the same page from is 2.5kHz (i.e. 2500 measurements per second). At the end of
43

WWW 2012 – Session: Mobile Web Performance April 16–20, 2012, Lyon, France
30
Android
| Multimeter |     |     | Server |     |       |     |     |     |     |     |     |     |     |
| ---------- | --- | --- | ------ | --- | ----- | --- | --- | --- | --- | --- | --- | --- | --- |
|            |     |     |        |     | Phone |     |     | 25  |     |     |     |     |     |
)se 20
setup
|     |     |     |     | request |     |     | lu  |     |     |     |     |     |     |
| --- | --- | --- | --- | ------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
o J( y 15
g
re 10
n
|     | start measurement |     |     |     |     |     | E   |     |     |     |     |     |     |
| --- | ----------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
5
|         |     |     |     | URL | load URL in  |     |     |     |     |     |     |     |     |
| ------- | --- | --- | --- | --- | ------------ | --- | --- | --- | --- | --- | --- | --- | --- |
| repeat  |     |     |     |     | browser      |     |     | 0   |     |     |     |     |     |
50
| for all  |     |     |     |     |     |     |     | 0 20 | 40 60 80 | 100 120 | 140 160 | 180 200 | 220 240 260 |
| -------- | --- | --- | --- | --- | --- | --- | --- | ---- | -------- | ------- | ------- | ------- | ----------- |
sec
URLs
|     |     | voltage numbers  |     |     |     |     |     |     |     | Data size (Kilo bytes) |     |     |     |
| --- | --- | ---------------- | --- | --- | --- | --- | --- | --- | --- | ---------------------- | --- | --- | --- |
voltage numbers
|     |     |     |     |     |     |     |     |     | 3G Download |     | 3G Upload |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | ----------- | --- | --------- | --- | --- |
rename
Figure5:Energyconsumptionover3G(downloadandupload)
file
Figure4:Automatedenergymeasurementsystem doesincreasewiththeamountofdatabeinguploaded. Theseob-
servationsareconsistentwithearlierwork[18,10].
theexperiment, allmeasurementsrecordedonthemultimeterare TheexperimentusedtogeneratethedatainFigure5separates
transferedtotheserverforprocessing. uploadactivityfromdownloadactivity. Thatis, theuploadnum-
Softwarechanges.Thebrowserismodifiedtocontainasingletab bersinthefigureareobtainedbysendingdatafromthephoneand
sothatallloadstakeplaceonthesametab.AfterloadingeachURL not using the radio for any other task. The download numbers
thebrowserisnavigatedtoanemptypagesothatallmeasurements are obtained similarly. A web browser, however, simultaneously
|                                    |     |     |     |                        |     |     | sends | HTTP | requests and | receives | HTTP | responses | using multi- |
| ---------------------------------- | --- | --- | --- | ---------------------- | --- | --- | ----- | ---- | ------------ | -------- | ---- | --------- | ------------ |
| startwiththebrowserinthesamestate. |     |     |     | Theserver-clientcommu- |     |     |       |      |              |          |      |           |              |
plethreadsasitrequestsandreceivesthevariouscomponentsthat
nicationtakesplaceover3GandnotUSBbecauseconnectingthe
makeupawebpage.
| phone to | a computer | via USB | starts | charging | the phone, | thereby |     |             |                  |     |          |               |         |
| -------- | ---------- | ------- | ------ | -------- | ---------- | ------- | --- | ----------- | ---------------- | --- | -------- | ------------- | ------- |
|          |            |         |        |          |            |         |     | Naively one | might conjecture |     | that the | energy needed | to send |
renderingthemeasurementunusable.
16kBandthenreceive16kBisthesumoftheenergiesforupload-
2.4 BatteryCapacityMeasurement inganddownloading16kBshowninFigure5.Butthisturnsoutto
befalse.Ourexperimentsshowthatamildinterleavingofuploads
AllourenergymeasurementsarestatedinJoulesormillijoules.
anddownloadsisessentiallydominatedbythecostoftheupload
| To make | sense of | these numbers | we  | often state | energy | used as a |     |     |     |     |     |     |     |
| ------- | -------- | ------------- | --- | ----------- | ------ | --------- | --- | --- | --- | --- | --- | --- | --- |
fractionofthetotalbatterycapacity. plusarelativelysmallquantity.Moreprecisely,supposeweupload
andthendownloada1kBchunkandrepeatthisprocesseighttimes
| To determine |     | the battery’s | energy | capacity | in Joules | we per- |     |     |     |     |     |     |     |
| ------------ | --- | ------------- | ------ | -------- | --------- | ------- | --- | --- | --- | --- | --- | --- | --- |
(thatis, weuploadatotalof8kBanddownloadatotalof8kBat
| formed the | following | simple | experiment. | We  | ran the | multimeter |     |                 |      |           |        |              |         |
| ---------- | --------- | ------ | ----------- | --- | ------- | ---------- | --- | --------------- | ---- | --------- | ------ | ------------ | ------- |
|            |           |        |             |     |         |            | 1kB | per iteration). | Then | the total | energy | used is only | 5% more |
for250secondssamplingthepowerconsumptionevery5millisec-
|              |       |             |     |          |           |         | thantheenergyneededtodirectlyupload8kBofdata. |     |     |     |     |     | Hence,the |
| ------------ | ----- | ----------- | --- | -------- | --------- | ------- | --------------------------------------------- | --- | --- | --- | --- | --- | --------- |
| onds. During | these | 250 seconds | we  | stressed | the phone | by con- |                                               |     |     |     |     |     |           |
uploadanddownloadenergiesinFigure5shouldnotbesummed
stantlybrowsingrandomwebpages.Attheendofthe250seconds
|     |     |     |     |     |     |     | toestimatetheradioenergyusedbyawebpage. |     |     |     |     | Instead,formild |     |
| --- | --- | --- | --- | --- | --- | --- | --------------------------------------- | --- | --- | --- | --- | --------------- | --- |
weobservedatotalenergyuseof229.88Joulesthatresultedina
|            |         |         |           |            |     |             | interleavingthecostisdominatedbytheuploadenergy. |     |     |     |     |     | Notethat |
| ---------- | ------- | ------- | --------- | ---------- | --- | ----------- | ------------------------------------------------ | --- | --- | --- | --- | --- | -------- |
| 7% drop in | battery | charge. | From this | experiment | we  | learned the |                                                  |     |     |     |     |     |          |
the3Gsetupcostisonlyincurredonce.
followingimportantfact:
Whenwerepeatedtheexperimentwithalargernumberofrepeti-
tions(256)theenergyusedbytheradiogrewtomorethanthesum
1%ofafullychargedbatteryis
approximately32.84Joules. ofthecorrespondingupload/downloadenergies.Thissuggests,and
|     |     |     |     |     |     |     | our | experiments | confirm, | that Figure | 5 should | not | be used when |
| --- | --- | --- | --- | --- | --- | --- | --- | ----------- | -------- | ----------- | -------- | --- | ------------ |
2.5 3GRadioEnergy
therearemanyroundtrips.
Tobetterunderstandtheenergyconsumedbythe3Gradiowe In summary, Figure 5 can be used to model applications that
measuredtheenergyneededtosetupa3Gconnectionwiththebase
|     |     |     |     |     |     |     | mostlyuseone-waycommunicationsuchasstreamingvideo. |     |     |     |     |     | For |
| --- | --- | --- | --- | --- | --- | --- | -------------------------------------------------- | --- | --- | --- | --- | --- | --- |
stationandtheenergyneededforvaryingpayloadsizes.
Webtraffic,thatinterleavesuploadsanddownloads,itcanbequite
Figure 5 shows the average energy needed for downloading or difficulttodefineanenergymodelthataccuratelypredictsthe3G
uploading4,8,16,32,64,128,and256kBover3G.Allmeasure- energyneededtofetchawebpagesinceenergyusedependsonthe
mentresultsareaveragedoverfiverunsandthestandarddeviation preciseshapeofthetraffic. Wedonotuseamodeltoestimatethe
islessthan5%. Inallmeasurementsthedisplaybrightnessisset radioenergyneededtofetchawebpage. Allourdataisderived
| totheminimumlevel.                           |     | Wemeasuredtheaverageidlepoweronthe |     |     |     |            | fromexperiments. |              |     |     |     |     |     |
| -------------------------------------------- | --- | ---------------------------------- | --- | --- | --- | ---------- | ---------------- | ------------ | --- | --- | --- | --- | --- |
| deviceandfoundittobe170millijoulespersecond. |     |                                    |     |     |     | Wesubtract |                  |              |     |     |     |     |     |
| thisnumberfromallourmeasurements.            |     |                                    |     |     |     |            | 3.               | MEASUREMENTS |     |     |     |     |     |
Energymodel. Usingtheinfrastructuredescribedintheprevioussectionweob-
Figure5showstwoimportantfactsabout3Gbe-
havior. First, forbothdownloadanduploadthereisahighsetup tain insights on the energy consumption of mobile web sites and
costofroughly12Joulesbeforethefirstbytecanbesent.Second, webelements.Wedescribeourexperimentsandfindingshere.
oncetheconnectionisestablished,theenergyneededtodownload
3.1 EnergyConsumptionofTopWebSites
| data is mostly | flat, | which means | that | roughly | the same | energy is |     |     |     |     |     |     |     |
| -------------- | ----- | ----------- | ---- | ------- | -------- | --------- | --- | --- | --- | --- | --- | --- | --- |
usednomatterhowmuchdataisdownloaded(upto256KB).The Our first experiment measures the energy consumption used
situation is a little different for uploading data where the energy by web pages at several top sites. We chose sites representing
44

WWW 2012 – Session: Mobile Web Performance April 16–20, 2012, Lyon, France
50
45
40
)s  35
e
lu30
o
J( y 25
g 20
re
n15
E
10
5
0
p   u   m   lia   la   e   y   a   n   c   n   tfo   te   o   s   o   lo   re   k   s   re   m   b   rlb   a   e
|     |     | u   | d o | m n b a b | s a | n b b o | g   | e e m | o a | h o | s e g | o d | id lp |     |
| --- | --- | --- | --- | --------- | --- | ------- | --- | ----- | --- | --- | ----- | --- | ----- | --- |
te ia c ru u tu e c c z a s o d g ta h a ta o b rp g c m m e p
|     |     | s G | b .e | g o         | ip  | m   | rc a   | ity | y   | e e | d o   | .o i | u p a |     |
| --- | --- | --- | ---- | ----------- | --- | --- | ------ | --- | --- | --- | ----- | ---- | ----- | --- |
|     |     |     | v    | j .ts lla o |     | a   | im g n | n n |     | w c | ro lb | g    | t ik  |     |
|     |     | 3   | il   | y           |     |     | e      |     |     | a f |       |      | iw    |     |
w
w
Figure6:Energyconsumptionoftopwebsites
|     | Website |     | Comment | %Battery | Traffic(bytes) |          |                                       |     |     |     |     |     |                  |     |
| --- | ------- | --- | ------- | -------- | -------------- | -------- | ------------------------------------- | --- | --- | --- | --- | --- | ---------------- | --- |
|     |         |     |         |          |                |          | TheresultingnumbersareshowninFigure6. |     |     |     |     |     | Notethattheerror |     |
|     |         |     |         | life     | Upload         | Download |                                       |     |     |     |     |     |                  |     |
m.gmail.com inbox 0.41 9050 12048 barsaresosmallthattheyarebarelyvisible.
m.picasa.com useralbums 0.43 8223 15475 The left most column in Figure 6 shows the energy needed to
m.aol.com portalhome 0.59 11927 37085 setupa3Gconnectionanddownloadafewbyteswithoutanyad-
|     | m.amazon.com       |     | productpage | 0.48 | 9523  | 26838 |                     |     |     |                                        |     |     |     |     |
| --- | ------------------ | --- | ----------- | ---- | ----- | ----- | ------------------- | --- | --- | -------------------------------------- | --- | --- | --- | --- |
|     |                    |     |             |      |       |       | ditionalprocessing. |     |     | Sinceallnavigationrequestsmustsetupa3G |     |     |     |     |
|     | mobile.nytimes.com |     | UShomepage  | 0.53 | 15386 | 66336 |                     |     |     |                                        |     |     |     |     |
connectionwetreatthismeasurementasabaselinewherethein-
|     | touch.facebook.com |     | facebookwall | 0.65 | 30214 | 81040 |     |     |     |     |     |     |     |     |
| --- | ------------------ | --- | ------------ | ---- | ----- | ----- | --- | --- | --- | --- | --- | --- | --- | --- |
mw.weather.com Stanfordweather 0.62 38253 134531 terestingdifferencesbetweenwebsitesareabovethisline.
apple.com homepage 1.41 86888 716835 Figure 6 is generated from the mobile versions of the web
m.imdb.com moviepage 0.97 30764 127924 site shown. The exceptions are apple.com, tumblr.com,
m.microsoft.com homepage 0.49 15240 47936 blogger.comandwordpress.comthatdonothaveamobileweb
|     | m.natgeo.com |     | homepage | 0.53 | 13877 | 76742 |     |     |     |     |     |     |     |     |
| --- | ------------ | --- | -------- | ---- | ----- | ----- | --- | --- | --- | --- | --- | --- | --- | --- |
site.Asaresult,theamountofdataneededtoretrievethesesitesis
|     | m.wikipedia.org |     | articlepage | 1.09 | 43699 | 308832 |     |     |     |     |     |     |     |     |
| --- | --------------- | --- | ----------- | ---- | ----- | ------ | --- | --- | --- | --- | --- | --- | --- | --- |
bbc.com mobilehomepage 0.46 20505 67004 significantlyhigherthanforotherwebsites. Forexample,Apple’s
|     | m.ebay.com |     | productpage | 0.42 | 8041 | 17941 |     |     |     |     |     |     |     |     |
| --- | ---------- | --- | ----------- | ---- | ---- | ----- | --- | --- | --- | --- | --- | --- | --- | --- |
pagecontainsmanyimages,includinga26kBwelcomeimagethat
|     | m.yahoo.com |     | portalhome | 0.55 | 14397 | 45564 |     |     |     |     |     |     |     |     |
| --- | ----------- | --- | ---------- | ---- | ----- | ----- | --- | --- | --- | --- | --- | --- | --- | --- |
ismostlywastedonthephonesincethephonescalesitdowntofit
|     | m.youtube.com  |     | homepage      | 0.55 | 5704  | 20329  |                  |        |          |                                     |            |          |        |        |
| --- | -------------- | --- | ------------- | ---- | ----- | ------ | ---------------- | ------ | -------- | ----------------------------------- | ---------- | -------- | ------ | ------ |
|     | baidu.com      |     | searchpage    | 0.39 | 2108  | 3951   | itssmallscreen.  |        |          |                                     |            |          |        |        |
|     | blogger.com    |     | homepage      | 0.94 | 45382 | 427788 |                  |        |          |                                     |            |          |        |        |
|     |                |     |               |      |       |        | Renderingenergy. |        |          | Nextwemeasuretheenergyneededtoparse |            |          |        |        |
|     | m.cnn.com      |     | headlinespage | 0.46 | 9311  | 33844  |                  |        |          |                                     |            |          |        |        |
|     |                |     |               |      |       |        | and              | render | the page | without                             | the energy | consumed | by the | radio. |
|     | m.engadget.com |     | portalpage    | 0.50 | 23334 | 80432  |                  |        |          |                                     |            |          |        |        |
m.go.com startpage 0.96 27965 154278 Thatis,wedeterminehowthecomplexityofthewebpageaffects
m.live.com personalpage 0.40 7319 12576 theenergyneededtorenderit.
wordpress.com homepage 0.90 23318 205140 Tomeasuretherenderingenergyweforcedthebrowsertolocally
|     | tumblr.com |     | homepage | 1.03 | 40543 | 889242 |       |     |             |     |               |     |             |     |
| --- | ---------- | --- | -------- | ---- | ----- | ------ | ----- | --- | ----------- | --- | ------------- | --- | ----------- | --- |
|     |            |     |          |      |       |        | cache | all | web content | and | then measured | how | much energy | was |
|     | m.wsj.com  |     | newspage | 0.41 | 4058  | 13653  |       |     |             |     |               |     |             |     |
usedtorenderthecontentfromlocalcache.Wemadesurethat:
|     |     |     |     |     |     |     |     | 1. There | was no | network | traffic | while rendering | from | local |
| --- | --- | --- | --- | --- | --- | --- | --- | -------- | ------ | ------- | ------- | --------------- | ---- | ----- |
Table1:Websitesusedinmeasuringenergyconsumption
cache,and
e-commerce, social networking, email, blogging, portals, news, 2. Thecacheddatawasidenticaltodatafetchedfromtheweb
videos,productandfinancialsectors. Thecompletelistofsitesis site,thatis,thebrowserdidnotpre-processthedatabefore
| showninTable1alongwiththeamountoftrafficinbytesneeded |        |     |          |                         |                    |                  |                                                    | cachingit. |                                            |     |     |                     |     |     |
| ----------------------------------------------------- | ------ | --- | -------- | ----------------------- | ------------------ | ---------------- | -------------------------------------------------- | ---------- | ------------------------------------------ | --- | --- | ------------------- | --- | --- |
| torequestanddownloadthepage.                          |        |     |          | Asummaryoftheenergycon- |                    |                  |                                                    |            |                                            |     |     |                     |     |     |
|                                                       |        |     |          |                         |                    |                  | Consequently,                                      |            | thisexperimentmeasurestheenergyusedtoparse |     |     |                     |     |     |
| sumedbythesesitesisshowninFigure6.                    |        |     |          |                         | Table1alsoshowsthe |                  |                                                    |            |                                            |     |     |                     |     |     |
|                                                       |        |     |          |                         |                    |                  | andrenderthepagewhenallcontentsarealreadyinmemory. |            |                                            |     |     |                     |     | The |
| energy                                                | needed | to  | download | and render the          | page               | as a fraction of |                                                    |            |                                            |     |     |                     |     |     |
|                                                       |        |     |          |                         |                    |                  | resultingnumbersareshowninFigure7.                 |            |                                            |     |     | Thepercentagesabove |     |     |
afullychargedbattery(computedusingthebatterymeasurements
thebarsshowtheenergytorenderthepageasafractionofthetotal
fromSection2.4).
energytodownloadandrenderthepage.
Weonlyincludemeasurementsfor10ofthe25sitesinFigure6.
Experimentdetails.Tomeasurethetotalenergyusedtodownload
Fortheremaining15sitescachingwebcontentdidnotpreventnet-
andrenderthepagewefirstmeasuredthephone’saverageenergy
|                                                   |     |     |     |     |     |      | worktraffic. |     | JavascriptandCSSatthesesitesgenerateddynamic |     |     |     |     |     |
| ------------------------------------------------- | --- | --- | --- | --- | --- | ---- | ------------ | --- | -------------------------------------------- | --- | --- | --- | --- | --- |
| consumptionwhenthebrowserisidle,whichis170mJ/sec. |     |     |     |     |     | Then |              |     |                                              |     |     |     |     |     |
webrequeststhatcouldnotbecachedaheadoftime.OntheApple
thewebpagestobemeasuredaredownloadedandsavedinare-
|     |     |     |     |     |     |     | homepage, |     | forexample, | theJavascriptusedfortrackinguserlo- |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --------- | --- | ----------- | ----------------------------------- | --- | --- | --- | --- |
moteserverrunningApachewebserver.WethenusedourBrowser
Profiler application to measure the energy consumption from the cation generates an update forcing the phone to setup a 3G con-
|     |     |     |     |     |     |     | nection. | Thus, | despitecaching, |     | energyconsumptionforthese10 |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | -------- | ----- | --------------- | --- | --------------------------- | --- | --- | --- |
momentthebrowserbeginsprocessingthenavigationrequestun-
|                            |     |                                              |     |                              |     |     | siteswasalmostashighaswhennocachingtookplace.     |           |        |          |        |          |          | Thereis |
| -------------------------- | --- | -------------------------------------------- | --- | ---------------------------- | --- | --- | ------------------------------------------------- | --------- | ------ | -------- | ------ | -------- | -------- | ------- |
| tilthepageisfullyrendered. |     |                                              |     | Eachmeasurementwasrepeatedup |     |     |                                                   |           |        |          |        |          |          |         |
|                            |     |                                              |     |                              |     |     | an                                                | important | lesson | here for | mobile | web site | design — | dynamic |
| totentimes.                |     | Thedifferencebetweentheidleenergymeasurement |     |                              |     |     |                                                   |           |        |          |        |          |          |         |
|                            |     |                                              |     |                              |     |     | Javascriptcangreatlyincreasethepowerusageofapage. |           |        |          |        |          |          | Wedis-  |
andtheenergywhenprocessingtherequestisthe(average)total
cussthisissuefurtherinSection7.
energyusedtodownloadandrenderthepage.Thisincludestheen-
ergyneededfor3Gcommunicationandforparsingandrendering Analysis. Figure 7 shows that mobile sites like baidu, that are
thepage,butdoesnotincludethephone’sidleenergyconsumption. mostlytextandverylittleJavascriptandnolargeimages,consume
45

WWW 2012 – Session: Mobile Web Performance April 16–20, 2012, Lyon, France
7
|     |     |     | 44.07% |     | 2.5 |     |     |     |     |
| --- | --- | --- | ------ | --- | --- | --- | --- | --- | --- |
| 6   |     |     | 32.37% |     |     |     |     |     |     |
40.49%
| 35.64%          | 31.71% 33.79% | 30.36% |        | 37.11% | 2   |     |     |     |     |
| --------------- | ------------- | ------ | ------ | ------ | --- | --- | --- | --- | --- |
| 5               |               | 22.49% |        |        |     |     |     |     |     |
| )seluoJ( ygrenE |               |        | 31.79% |        |     |     |     |     |     |
| 4               |               |        |        |        | )se |     |     |     |     |
lu 1.5
|     |     |     |     |     | o           |        |     | 20.35% |     |
| --- | --- | --- | --- | --- | ----------- | ------ | --- | ------ | --- |
| 3   |     |     |     |     | J( y 16.89% |        |     |        |     |
| 2   |     |     |     |     | g 1         | 15.62% |     |        |     |
re
| 1   |     |     |     |     | n   |     |       |     |     |
| --- | --- | --- | --- | --- | --- | --- | ----- | --- | --- |
|     |     |     |     |     | E   |     | 6.79% |     |     |
0.5
0
| gmail | amazon picasa | aol microsoft | yahoo youtube | baidu live.com wall  |     |     |     |     |     |
| ----- | ------------- | ------------- | ------------- | -------------------- | --- | --- | --- | --- | --- |
street
0
journal
(PercentagesshowenergyrelativetoFigure6) amazon picasa yahoo youtube
Figure7:Renderingenergyoftopwebsitesfromcache Rendering Energy Total Energy (Transmission + Rendering)
| 3   | 20.56% |     |     |        |                                       |     |     |     |     |
| --- | ------ | --- | --- | ------ | ------------------------------------- | --- | --- | --- | --- |
|     |        |     |     | 18.89% | Figure9:EnergyconsumptionofJavascript |     |     |     |     |
2.5
15.53%
| )se 2 |     |     | 2.87% | 24.22% |     |     |     |     |     |
| ----- | --- | --- | ----- | ------ | --- | --- | --- | --- | --- |
lu 6.86%
| o   |     |     |     |     | totalrenderingenergy.SomesiteslikeYoutubespendaroundquar- |     |     |     |     |
| --- | --- | --- | --- | --- | --------------------------------------------------------- | --- | --- | --- | --- |
J( ygre 1. 5
17.09% ter o f th e ir r e n d er in g e n e rg y o n i m a g e s .
n 1 T h e a m o u n t o f en e r g y u se d t o r e n d e rimagesisproportionalto
E
|     |     |     |     |     | thenumberandsizeofimagesonthepage. |     |     | TheYoutubepagehas |     |
| --- | --- | --- | --- | --- | ---------------------------------- | --- | --- | ----------------- | --- |
0.5
5largeimagesrepresentingascreenshotfromeachvideowhichis
| 0   |     |     |     |     | why24.22%ofthetotalenergytorenderthepageisspentonim- |     |     |     |     |
| --- | --- | --- | --- | --- | ---------------------------------------------------- | --- | --- | --- | --- |
gmail amazon picasa aol microsoft yahoo youtube ages.Gmail,incontrast,containsonlysmallGIFs(13pixelswide)
andimagestakeasmallerfractionofthetotalenergy(6.86%).We
|     | Rendering Energy | Total Energy (Transmission + Rendering) |     |     |     |     |     |     |     |
| --- | ---------------- | --------------------------------------- | --- | --- | --- | --- | --- | --- | --- |
foundthatonesmallGIFontheGmailpageisrepeated16times.
| Figure8: | Energyconsumedbyimages. |     | Thepercentagenum- |     |     |     |     |     |     |
| -------- | ----------------------- | --- | ----------------- | --- | --- | --- | --- | --- | --- |
ThisGIFindicateswhetheranemailwassenttoasinglerecipient
bersrefertothetotalenergyneededtorenderimagesasafrac-
oragroup.
tionoftheenergyforrenderingtheentirepage.
Picasaspendsalargefractionofitsrenderingenergy(20.56%)
|               |                |        |                    |           | on images    | because the user | album page | contains 8 large | album |
| ------------- | -------------- | ------ | ------------------ | --------- | ------------ | ---------------- | ---------- | ---------------- | ----- |
| little energy | to render. The | Amazon | site that contains | a product | coverimages. |                  |            |                  |       |
imagetakemoreenergy.Siteslikeyoutubeandyahoothatcontain
|     |     |     |     |     | Javascript. | Figure 9 shows | similar measurements | for Javascript |     |
| --- | --- | --- | --- | --- | ----------- | -------------- | -------------------- | -------------- | --- |
images,Javascript,andCSStakeconsiderablymoreenergytoren-
|     |     |     |     |     | onwebpages. | Ofthecachablewebsitesthatweconsideredonly |     |     |     |
| --- | --- | --- | --- | --- | ----------- | ----------------------------------------- | --- | --- | --- |
der. Westudytheprecisereasonforthesedifferencesinthenext Amazon,Picasa,YoutubeandYahoohaveJavascript.
section.
Amazonconsumes16.89%ofitsrenderingenergyforhandling
|     |     |     |     |     | Javascript. | The reason for | the large rendering | cost is a large | and |
| --- | --- | --- | --- | --- | ----------- | -------------- | ------------------- | --------------- | --- |
3.2 EnergyConsumptionofWebComponents
|     |     |     |     |     | complex Javascript | file. Many | of the Javascript | functions | in the |
| --- | --- | --- | --- | --- | ------------------ | ---------- | ----------------- | --------- | ------ |
Next,welookattheenergyconsumptionofindividualwebele- filearenotusedbythepagebutloadingandprocessingtheentire
mentssuchasimages,Javascript,cascadestylesheets(CSS),etc. Javascriptfileconsumesalotofenergy.
The question is how much energy is used by different web ele- Yahoo’s Javascript code is embedded in the HTML page. The
ments. amountofJavascriptcodeisverysmallbutthecodegetsexecuted
Tomeasuretheenergyusedbyaparticularelementwecreated everytimethepageloads. AsaresultJavascriptprocessingtakes
acopyofthewebpageonourserversandthencomparedtheen- only6.79%ofthetotalrenderingenergy.TheJavascriptcodehere
ergyconsumptionusedforloadingandrenderingtheentirepageto isminimalandfullyusedinthepage. Youtube’sJavascriptisem-
theenergyconsumptionneededforloadingandrenderingthepage beddedbutissoheavythatittakes20.35%ofthetotalenergy.
withtheparticularcomponentremovedbycommentingitout.The
differencebetweenthetwonumbersgivesanestimatefortheen- Cascade Style Sheets (CSS). Finally, Figure 10 shows energy
ergy needed to present the component. These experiments were measurementsforCSS.TherenderingcostofCSSdependsonthe
runonwebsitesthatcontainspecificcomponents(Figure 7). For number of items styled using CSS. Amazon has a high CSS ren-
example,ourresultsforJavascriptareillustratedinFigure9. deringcost(17.57%)sinceabout104itemsinthepageusestyling
Asintheprevioussectionwefirstmeasuredthetotalenergyused defined in the CSS file. Amazon also has complex styling in the
for loading and rendering each component, which includes both pagelikeacolorfadeouteffect, horizontalbarstoshowproduct
renderingandtransmissionenergy. Wethenmeasuredparsingand ratings,andhugewidebuttons. Gmailhassimplestylingdefined
renderingenergyalonebyforcingthebrowsertocacheallcontent inaninternalstylesheet. TheCSSisverysmallanditconsumes
| locallyonthephone. |     |     |     |     | only3%ofthetotalrenderingenergy. |     |     |     |     |
| ------------------ | --- | --- | --- | --- | -------------------------------- | --- | --- | --- | --- |
AOLandPicasabothcontainlargeimagesbuttheCSSenergy
Images.
Figure8showsenergymeasurementsforimagesonweb consumptionforAOLismuchlowerthanPicasa’s. Thereasonis
pages.Thebarsontherightcorrespondtothetotalenergyspenton that AOL uses HTML tables to position its images while Picasa
images. Thebarsontheleftshowtherenderingenergyforcached usesCSStopositionimages. Thisnicelyillustrateshowposition-
images. Thepercentageabovetheleftbarshowstheenergyspent ingusingCSSislessenergyefficientthanpositioningusingsimple
| onrenderingimagesasafractionoftheenergyforrenderingthe |     |     |     |     | HTMLtags. |     |     |     |     |
| ------------------------------------------------------ | --- | --- | --- | --- | --------- | --- | --- | --- | --- |
entirepagefromcache. MicrosoftandYahoopagesuselargeCSSfilesthatcausesavery
Asexpected,renderingimagestakesasignificantfractionofthe hightransmissionenergycosttodownloadthefile.
46

WWW 2012 – Session: Mobile Web Performance April 16–20, 2012, Lyon, France
|     | 4   |     |     |     |     | TheJavascriptinjquery.jsisusedprimarilyforasinglepurpose- |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --------------------------------------------------------- | --- | --- | --- | --- | --- |
12.42%
todynamicallyidentifythecorrectsectionbasedontheidofthe
3.5
3 9.9% button clicked. But loading this Javascript to the memory alone
)se
|     |     |     |     |     |     | tak e s 4 J | o ul e s. |     |     |     |     |
| --- | --- | --- | --- | --- | --- | ----------- | --------- | --- | --- | --- | --- |
lu 2.5
o 17.38% I n o rd e r t o prove that this energy is avoidable, we redesigned
J( y 2
|         |     |               |     |     |     | the page       | with a different | Javascript. | This   | time           | each text section |
| ------- | --- | ------------- | --- | --- | --- | -------------- | ---------------- | ----------- | ------ | -------------- | ----------------- |
| g re1.5 |     | 17.57% 17.54% |     |     |     |                |                  |             |        |                |                   |
|         |     |               |     |     |     | and the button | are given        | the same    | id and | the Javascript | function          |
n E
|     | 1   |     |     |     |     | usesdocument.getElementById()togettherightsectionandele- |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | -------------------------------------------------------- | --- | --- | --- | --- | --- |
0.5 1.1% ment.value=show/hideisused. Theapplication.jsisnowreplaced
3.05%
|     |     |     |     |     |     | bythissimpleJavascript. |     | Wefoundthatincachemode,themodi- |     |     |     |
| --- | --- | --- | --- | --- | --- | ----------------------- | --- | ------------------------------- | --- | --- | --- |
0
fiedWikipediapagerenderswith9.5Joules.Justaddingtheappli-
|     | gmail | amazon picasa |     | aol microsoft | yahoo youtube |     |     |     |     |     |     |
| --- | ----- | ------------- | --- | ------------- | ------------- | --- | --- | --- | --- | --- | --- |
cation.jsandjquery.jsfilesaslinktothepageincreasestheenergy
|     | Rendering Energy |     | Total Energy (Transmission + Rendering) |     |     |     |     |     |     |     |     |
| --- | ---------------- | --- | --------------------------------------- | --- | --- | --- | --- | --- | --- | --- | --- |
consumptionto15Joules.
|     |     |     |     |     |     | This experiment | shows | that shrinking |     | Javascript | on a mobile |
| --- | --- | --- | --- | --- | --- | --------------- | ----- | -------------- | --- | ---------- | ----------- |
Figure10:Energyconsumptionofcascadestylesheets
|     |     |     |     |     |     | page to contain | only functions | used       | by the | page      | greatly reduces |
| --- | --- | --- | --- | --- | --- | --------------- | -------------- | ---------- | ------ | --------- | --------------- |
|     |     |     |     |     |     | energy use.     | Using generic  | Javascript |        | libraries | simplifies web  |
100%
90%  development,butincreasestheenergyusedbytheresultingpages.
80%
| 70%  |     |     |     |     |     | 4.2 ReducingCSSPowerConsumption |     |     |     |     |     |
| ---- | --- | --- | --- | --- | --- | ------------------------------- | --- | --- | --- | --- | --- |
60%
50%
SimilartothepreviousexperimentwefoundthatlargeCSSfiles
40%
| 30%  |     |     |     |     |     | withunusedCSSrulesconsumemorethanminimumrequireden- |     |     |     |     |     |
| ---- | --- | --- | --- | --- | --- | --------------------------------------------------- | --- | --- | --- | --- | --- |
20%
10%  ergy. For example, Apple consumes a large amount of energy to
0%
                                d o w n l o a d a n d r e n d e r C S S ( F i g u r e 1 0 ) . T h e t o ta l e n e r g y to d o w n -
|     | koobecaf liam rehtaew | nozam sem elppa | asacip loa | bdm tfosorcim oegtan | aidepikiw cbb yabe oohay ebutuoy |     |     |     |     |     |     |
| --- | --------------------- | --------------- | ---------- | -------------------- | -------------------------------- | --- | --- | --- | --- | --- | --- |
g ityn i l o a d a n d r e n d e r C S S o f t h i s p a g e i s a r o u n d 1 2 J o u l e s . T h is i s b e -
a
|     |     |         |                   |         |     | c a u s e th e | A p p l e h o m e | p a g e r e q u i | r e s 5 d i f f | e r e n t C | S S fi le s c o n ta in - |
| --- | --- | ------- | ----------------- | ------- | --- | -------------- | ----------------- | ----------------- | --------------- | ----------- | ------------------------- |
|     |     | images  | css  java script  | others  |     |                |                   |                   |                 |             |                           |
ingdifferentrulesusedinthepage.
Figure 11: Total energy consumption of web components WemodifiedtheApplesitebyreplacingmultipleCSSfileswith
(Transmission+Rendering) just one CSS file containing just the rules required by the page.
|     |     |     |     |     |     | Thisresultedinanenergydropof5Joules. |     |     |     | Thisisabout40%of |     |
| --- | --- | --- | --- | --- | --- | ------------------------------------ | --- | --- | --- | ---------------- | --- |
thetotalCSSenergyconsumedbyApple.Thisenergycanbesaved
Therelativeenergyusedonwebcomponents.Forcompleteness, byusingaCSSfilewithonlytherequiredCSSrules.
Figure11showstherelativecostsofindividualcomponents. The ThisshowsthatlikeJavascript,CSSfileshouldbepagespecific
general trend across web sites is that CSS and Javascript are the andcontainonlytherulesrequiredbytheelementsinthepage.
| most | energy consuming | components |     | in the transmission | and ren- |           |          |     |            |     |           |
| ---- | ---------------- | ---------- | --- | ------------------- | -------- | --------- | -------- | --- | ---------- | --- | --------- |
|      |                  |            |     |                     |          | 4.3 Image | Formats: |     | Comparison |     | and Opti- |
deringofasite.Thevalueof’others’inthegraphmainlyincludes
| the3Gconnectionsetupcostandtextrendering. |     |     |     |     |     | mization |     |     |     |     |     |
| ----------------------------------------- | --- | --- | --- | --- | --- | -------- | --- | --- | --- | --- | --- |
Sitesthathavehigh’others’(suchasAOL,EbayandGmail)can Thewebsitesweanalyzeduseavarietyofimageformats,with
become more efficient as wireless technology improves and con- JPEG, GIF, and PNG being the most common. Since the energy
nectionsetupcostdecreases.Siteswithlow’others’(suchasApple neededtorenderanimagedependsontheencodingformatweset
andIMDB)spendmuchoftheirenergyonwebelementsandwill outtocomparetheenergysignaturefordifferentformats.Wefocus
notgainmuchfromimprovementsinwirelesstechnology. Thus, onthesethreepredominantformats.
Figure11isanothermethodforcomparingwebsiteefficiency. Recall that the GIF format supports 8-bits per pixel and uses
theLempel-Ziv-Welch(LZW)losslessdatacompressionmethod.
4. OPTIMIZINGMOBILEWEBPAGES PNG is similarly a bitmapped image format that was created to
improveuponandreplaceGIF.PNGalsouseslosslessdatacom-
Powerhungrywebcomponentsincludeimages,Javascript,and
CSS.Inthissectionweshowhowtooptimizewebpagessoasto pression. JPEGisanotherpopularimageformatusinglossydata
compression.
reducethepowerconsumptionoftheseelements.
|     |     |     |     |     |     | On the | mobile web | sites we examined |     | GIFs were | mostly used |
| --- | --- | --- | --- | --- | --- | ------ | ---------- | ----------------- | --- | --------- | ----------- |
4.1 ReducingJavascriptPowerConsumption forverysmallimagessuchassmallarrowsandicons,PNGswere
usedforlargerimagessuchasbannersandlogos,andJPEGswere
Javascriptisoneofthemostenergyconsumingcomponentsin
usedforlargeimages.
| a web | page. Figure | 9 shows | a   | high download | and rendering |     |     |     |     |     |     |
| ----- | ------------ | ------- | --- | ------------- | ------------- | --- | --- | --- | --- | --- | --- |
energy required by most of the websites for Javascript. This is Image formats for different dimensions. Figure 12 shows the
mainlybecausethesewebpagesloadlargeJavascriptfilesforren- energyconsumptionneededtodownloadandrenderimagesofdif-
deringthewebpageeventhoughnotallofthescriptisusedbythe ferentsizesinthethreeformatsontheAndroidphone.
page.Forexample,thedownloadandrenderingofJavascriptinthe ThisexperimentusedaJPEGimageofdimensions1600x1200
Wikipedia page takes about 10 Joules. This is about 30% of the andsize741kB.Smallerimagesofdifferentheightandwidthare
totalenergytodownloadandrenderthepage. cropped from this image as shown on the x-axis. We then saved
The Wikipedia webpage has two Javascript files linked to the thecroppedimagesasJPEG,GIFandPNGs.Eachimagewasthen
page - application.js and jquery.js. The application.js is the embeddedinawebpagethatcontainedtheimageandnothingelse.
Javascript specific to the Wikipedia site and the jquery.js is the Energy needed to download and render each image is measured
genericjqueryJavascriptlibrary. IntheWikipediapageeachsec- forallsizesshownonthex-axiswiththeenergyalongthey-axis.
tionofthepagelikeIntroduction, TableofContents, etc. canbe SinceGIFandPNGareonlyusedforsmallimages,weonlyexper-
collapsedandexpandedbytheclickofabuttonaboveeachsection. imentedwiththeseformatsforsmallimages.
47

WWW 2012 – Session: Mobile Web Performance April 16–20, 2012, Lyon, France
Image download + rendering energy  Image download + rendering energy
| 1.4                   |     |                      |     |     |         |                 | 1.4   |     |     |                      |                |     |     |     |
| --------------------- | --- | -------------------- | --- | --- | ------- | --------------- | ----- | --- | --- | -------------------- | -------------- | --- | --- | --- |
| 1.2                   |     |                      |     |     |         |                 | 1.2   |     |     |                      |                |     |     |     |
| 1.0                   |     |                      |     |     |         |                 | 1.0   |     |     |                      |                |     |     |     |
| )seluoJ( ygrenE 0 . 8 |     |                      |     |     |         | )seluoJ( ygrenE | 0 . 8 |     |     |                      |                |     |     |     |
| 0 . 6                 |     |                      |     |     |         |                 | 0 . 6 |     |     |                      |                |     |     |     |
| 0 . 4                 |     |                      |     |     |         |                 | 0 . 4 |     |     |                      |                |     |     |     |
| 0.2                   |     |                      |     |     |         |                 | 0.2   |     |     |                      |                |     |     |     |
| 0.0                   |     |                      |     |     |         |                 | 0.0   |     |     |                      |                |     |     |     |
| 0 100                 |     | 200 300              | 400 | 500 | 600 700 |                 | 0     | 100 | 200 | 300                  | 400            | 500 | 600 | 700 |
|                       |     | Image width (pixels) |     |     |         |                 |       |     |     | Image width (pixels) |                |     |     |     |
|                       |     | JPEG                 | GIF | PNG |         |                 |       |     |     | JPEG                 | Offload Energy |     |     |     |
Figure12:Energyconsumptionforimageformats
Figure13:Thebenefitsofoffloadingimages
Figure12showsthatJPEGisthemostenergyefficientformaton
theAndroidphoneforallimagesizes. Tofurtherdrivethispoint 5.1 OffloadingviaaFront-endProxy
homeweusedMogrifytoconvertallimagesontheAmazonand
|     |     |     |     |     |     |     | Some sites, | like | apple.com, |     | do not have | a mobile |     | version. |
| --- | --- | --- | --- | --- | --- | --- | ----------- | ---- | ---------- | --- | ----------- | -------- | --- | -------- |
FacebookpagestoJPEGusingastandard92%qualitycompression
|     |     |     |     |     |     | Phones | visiting | these | sites | unnecessarily | download |     | large | images. |
| --- | --- | --- | --- | --- | --- | ------ | -------- | ----- | ----- | ------------- | -------- | --- | ----- | ------- |
measure.Wethenmeasuredtheenergyconsumptionforrendering
Anaturalapplicationforafront-endproxyistoresizeimagesto
theresultingimagesfromcacherelativetotheoriginalimagesand
fitthephonescreen,therebysavingradiouseandrenderingwork.
obtainedthefollowingresults Thenaturalplaceforafront-endproxyisatthecarrier’sdatacenter
wherethecarriercanoptionallyplaytheroleoftheproxy.
|     |     | Amazon | Facebook |     |     |     |     |     |     |     |     |     |     |     |
| --- | --- | ------ | -------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
Site (Joules) (Joules) Figure13showstheenergysavingsthatresultfromafront-end
Original 2.54 3.43 proxythatdown-scalesalllargeJPEGimagesto160pixelwidth.
JPEG 2.04 2.39 The blue line is the energy needed to download JPEG images of
Savings 20% 30% varioussizeswhennofront-endproxyisused. Thislineisgener-
ThetableshowsthatbothAmazonandFacebookcanconserveen- atedusingthesamecroppingsetupusedinFigure12. Thegreen
ergy on Android phones by converting all their images to JPEG, line shows the saving from a front-end proxy. Since all images
withoutimpactingthevisiblequalityoftheimages.Thereasonfor largerthan160x160arescaleddownbytheproxy,theenergybe-
thesavingsisthatJPEGcompressestheimagesbetterandisfaster yondthatimagesizeisflat.
torenderthenPNGandGIF. Theareabetweenthegreenlineandthebluelinerepresentsthe
|     |     |     |     |     |     | energysavingsonthephone. |     |     |     | OntheApplehomepage,forexam- |     |     |     |     |
| --- | --- | --- | --- | --- | --- | ------------------------ | --- | --- | --- | --------------------------- | --- | --- | --- | --- |
5. OFFLOADING BROWSER COMPUTA- ple,thisfront-endproxywouldsave1.77Joulesoneverypageload
withlittleimpacttotheuserexperience.Whiledownscalingisnot
TION
|     |     |     |     |     |     | a   | new idea, | we are | not aware | of  | any quantitative |     | measurements |     |
| --- | --- | --- | --- | --- | --- | --- | --------- | ------ | --------- | --- | ---------------- | --- | ------------ | --- |
Giventhephone’slimitedenergythereisastrongdesiretomin- showingitsimpactonmodernphonessuchastheAndroidADP2.
imizeitswork.Anaturalideaistooffloadheavycomputationstoa Wehopetheseresultsmakeacompellingcaseforthisservice.
servercloudandhavethephonedisplaytheresults[13].Inthecon-
textofwebbrowsingonecouldoffloadimagerendering—includ- Down-scalingisnotwithoutlimitations:
ingdecompressionandconversiontoabitmap—tothecloudand
|     |     |     |     |     |     |     | • By down-scaling |     | images, | users | loose | the ability | to  | quickly |
| --- | --- | --- | --- | --- | --- | --- | ----------------- | --- | ------- | ----- | ----- | ----------- | --- | ------- |
havethephonesimplydisplaytheresultingbitmap.Somebrowsers
|     |     |     |     |     |     |     | zoom | in on | intricate | image | details. | Instead, | a zoom-in | re- |
| --- | --- | --- | --- | --- | --- | --- | ---- | ----- | --------- | ----- | -------- | -------- | --------- | --- |
suchasOpera[7]andSkyFire[6]takethisapproach. Theirphone quiresdownloadingthezoomedpartoftheimage. Butthe
browsers talk to the web through a proxy that does most of the morecommoncaseisthatnozoomingtakesplace.
heavyliftingofrenderingthepage.
• ForcontentsentencryptedusingSSL,theproxycannotsee
Generallyspeaking,therearetwoapproachestooffloadingcom-
|     |     |     |     |     |     |     | the content | and | therefore |     | cannot down-scale |     | it. However, |     |
| --- | --- | --- | --- | --- | --- | --- | ----------- | --- | --------- | --- | ----------------- | --- | ------------ | --- |
putation:
down-scalingcleartextHTTPcontentisalreadyawin.
| • Front-end | proxy: | a web | proxy examines |     | all traffic to the |     |     |     |     |     |     |     |     |     |
| ----------- | ------ | ----- | -------------- | --- | ------------------ | --- | --- | --- | --- | --- | --- | --- | --- | --- |
Down-scalingcanbeofferedasanopt-in/opt-outoptiontousersto
| phone and | partially | renders | the page | to  | save work for the |     |     |     |     |     |     |     |     |     |
| --------- | --------- | ------- | -------- | --- | ----------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
improvethebrowsingexperienceonthephone.
| phone. Here                       | the | proxy decides | how | the             | content should be |     |     |     |     |     |     |     |     |     |
| --------------------------------- | --- | ------------- | --- | --------------- | ----------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| modifiedbeforeitissenttothephone. |     |               |     | Thisapproachwas |                   |     |     |     |     |     |     |     |     |     |
5.2 OffloadingviaaBack-endServer
| previously | used | by old WAP | gateways |     | as they translated |     |     |     |     |     |     |     |     |     |
| ---------- | ---- | ---------- | -------- | --- | ------------------ | --- | --- | --- | --- | --- | --- | --- | --- | --- |
HTML to WAP. This approach is also used by Opera and Another option for offloading computation is to let the phone
SkyFire, but is not used by the default Android or iPhone browsersendsub-taskstoaback-endserver. Forimages, forex-
|     |     |     |     |     |     | ample, | the | cost of | loading | a compressed | image | and | converting | it  |
| --- | --- | --- | --- | --- | --- | ------ | --- | ------- | ------- | ------------ | ----- | --- | ---------- | --- |
browsers.
|     |     |     |     |     |     | to  | a bitmap | can be | offloaded. | In  | this example | we  | are potentially |     |
| --- | --- | --- | --- | --- | --- | --- | -------- | ------ | ---------- | --- | ------------ | --- | --------------- | --- |
• Back-end server: the phone downloads web content as is, reducingCPUworkatthecostofincreasinguseoftheradio. We
but then offloads certain operations to a server farm. Here studywhenthistrade-offisworthwhile.
thephonedecideswhatneedstobeoffloaded. Astechnologyimprovesweexpecttoseethefollowingtrends:
In the next two section we discuss both approaches and measure • CPU energy consumption per instruction will continue to
| theirenergysavings. |     |     |     |     |     |     | drop,and |     |     |     |     |     |     |     |
| ------------------- | --- | --- | --- | --- | --- | --- | -------- | --- | --- | --- | --- | --- | --- | --- |
48

WWW 2012 – Session: Mobile Web Performance April 16–20, 2012, Lyon, France
Amazonimages Pagesize Energy comparison,ourfocusisonhelpingwebdevelopersbuildmoreen-
|     | convertedto: |      | (kB) (mJ)    |     |     | ergyefficientwebpages. |     |     |     |     |     |     |     |
| --- | ------------ | ---- | ------------ | --- | --- | ---------------------- | --- | --- | --- | --- | --- | --- | --- |
|     |              | JPEG | 26.45 224.68 |     |     |                        |     |     |     |     |     |     |     |
PNG 65.53 268.05 Other related measurement works include a study of the per-
Bitmap(BMP) 75.19 362.49 formance of 3G network and applications on smartphones [17,
|     |     |     |     |     |     | 23]. Huang | et  | al. [17] | show | that 3G | connections |     | suffer from |
| --- | --- | --- | --- | --- | --- | ---------- | --- | -------- | ---- | ------- | ----------- | --- | ----------- |
Table 2: Energy to render all the images in Amazon page in verylonglatenciesandslowdatatransfers,whichmayleadtoin-
multipleformats creasedenergyconsumption.Zhuangetat.[23]presentalocation-
|     |     |     |     |     |     | sensing | framework | to improve |     | the energy | efficiency |     | of localiza- |
| --- | --- | --- | --- | --- | --- | ------- | --------- | ---------- | --- | ---------- | ---------- | --- | ------------ |
tiononsmartphonesthatrunmultiplelocation-basedapplications.
|     |     |     |     |     |     | The authors | present | four | design | principles | that | minimize | energy, |
| --- | --- | --- | --- | --- | --- | ----------- | ------- | ---- | ------ | ---------- | ---- | -------- | ------- |
• Theenergyneededtotransmitorreceiveonebytefromthe
i.e.,accelerometer-basedsuppression,location-sensingpiggyback-
phonetothebasestationwillstayroughlyconstantincom-
|     |     |     |     |     |     | ing, substitution |     | of location-sensing |     | mechanisms, |     | and | adaptation |
| --- | --- | --- | --- | --- | --- | ----------------- | --- | ------------------- | --- | ----------- | --- | --- | ---------- |
parison.
ofsensingparameterswhenbatteryislow.Ourworkcomplements
ThefirstassumptionisaqualitativeversionofMoore’slaw. The theseworkswithdifferentfocusandmethodology.
secondassumptionisduetothelawsofphysics:theenergyneeded Partitioning applications. Prior works [16, 15, 20] investigated
toreachabasestationatacertaindistanceis“roughly”constant.
|     |     |     |     |     |     | strategies | for reducing |     | the energy | consumption |     | of mobile | phones |
| --- | --- | --- | --- | --- | --- | ---------- | ------------ | --- | ---------- | ----------- | --- | --------- | ------ |
By“roughly”wemeanthattransmissionenergywilllikelydropat
byexecutingcoderemotely.Flinnetal.[16,15]proposestrategies
afarslowerpacethantherateofdropinCPUenergy.
onhowtopartitionaprogram,howtohandlestatemigrationand
Giventhesetwotrends,itshouldbeclearthatoffloadingisnot
adaptationofprogrampartitioningschemetochangesinnetwork
| viable in the | long | run if it results | in more radio | use. | In fact, as |             |                                            |     |     |     |     |     |     |
| ------------- | ---- | ----------------- | ------------- | ---- | ----------- | ----------- | ------------------------------------------ | --- | --- | --- | --- | --- | --- |
|               |      |                   |               |      |             | conditions. | Osmanetal.[20]andChunetal.[12]proposeusing |     |     |     |     |     |     |
CPUenergyperinstructiondecreasesitisfarbettertomaximize
|     |     |     |     |     |     | full process | or  | VM migration |     | to allow | remote | execution | without |
| --- | --- | --- | --- | --- | --- | ------------ | --- | ------------ | --- | -------- | ------ | --------- | ------- |
theamountofcomputationonthephoneinordertominimizeuse
modifyingtheapplicationcode.
oftheradio.
|     |     |     |     |     |     | Cuervoy | et al. | [13] proposed |     | a way | to offload | heavy | computa- |
| --- | --- | --- | --- | --- | --- | ------- | ------ | ------------- | --- | ----- | ---------- | ----- | -------- |
Nevertheless,itispossiblethatwithcurrenttechnologyoffload-
tionstoaservercloudandhavethemobilephonedisplaythere-
ingimagerenderingtoaback-endserversavesenergy. Ifso,then sults.Inthecontextofwebbrowsing,onecouldoffloadimageren-
onecouldenvisionanarchitecturewherethephonesendsanimage deringtothecloudanddisplaytheresultsbacktothephone.While
URLtoaback-endserver.Theback-endserverretrievestheimage,
thisworkswellformanyapplications,ourexperimentssuggestthat
convertsittoaplainbitmap,andsendstheresulttothephone.The
thisapproachdoesnotimprovebrowserefficiency.Weshowedthat
phonesimplycopiesthebitmaptoitsvideobuffer.
|     |     |     |     |     |     | front-end | offloading, | as  | done by | SkyFire | [6] | and Opera | [7], can |
| --- | --- | --- | --- | --- | --- | --------- | ----------- | --- | ------- | ------- | --- | --------- | -------- |
Totestwhetherthisarchitecturesavesenergywecomparedthe
greatlyreduceenergyuseonthephone.
costoffetchingandrenderingcompressedJPEGsandPNGstofull
Severalpreviousstudies[14,21]alsoinvestigatedtheuseofau-
bitmaps(BMP).WeconvertedalltheimagesontheAmazonpage
|     |     |     |     |     |     | tomatic program |     | partitioning. |     | Hunt et | al. [14] | develop | strategies |
| --- | --- | --- | --- | --- | --- | --------------- | --- | ------------- | --- | ------- | -------- | ------- | ---------- |
tooneofJPEG,PNGorBMP.Wethenmeasuredthecostofrender-
|     |     |     |     |     |     | to automatic | partitioning |     | of DCOM |     | applications | into | client and |
| --- | --- | --- | --- | --- | --- | ------------ | ------------ | --- | ------- | --- | ------------ | ---- | ---------- |
ingtheimagesonthepagefromcacheforeachofthethreeformats
servercomponentswithoutmodifyingtheapplicationsourcecode.
andtheresultsareinTable2.
Weinsbergetal.[22]proposeanapproachtooffloadcomputation
AsalreadysuggestedinFigure12,JPEGisbyfarthemostef- tospecializeddiskcontrollersandprocessors(i.e.,NICs).
| ficientencodingandPNGisthesecond. |     |     | BMPisbyfartheworst |     |     |     |     |     |     |     |     |     |     |
| --------------------------------- | --- | --- | ------------------ | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
eventhoughitrequiresnodecompression. Wesuspectthereason 7. SUMMARYANDDISCUSSION
BMPdoessopoorlyisthatBMPimagesareconsiderablybigger
Whilewebpagesareoftenoptimizedforspeedandbeauty,little
andtheextraenergyneededtokeeptheradioonfaroutweighsthe
attentionisgiventotheamountofpowerneededtodownloadand
costofdecompressingtheimage.
| Basedonthisexperimentweconcludethatback-endoffloading |     |     |     |     |     | renderthepage. |     |     |     |     |     |     |     |
| ----------------------------------------------------- | --- | --- | --- | --- | --- | -------------- | --- | --- | --- | --- | --- | --- | --- |
ofimagerenderingisnotviableevenwithtoday’stechnology. We presented an experimental framework for measuring the
|     |     |     |     |     |     | powerconsumptionofwebpages, |     |          |       | includingspecificcomponents |           |     |              |
| --- | --- | --- | --- | --- | --- | --------------------------- | --- | -------- | ----- | --------------------------- | --------- | --- | ------------ |
|     |     |     |     |     |     | on the page.                | Our | approach | gives | another                     | dimension |     | for evaluat- |
6. RELATEDWORK
ingmobilewebsitesandhelpswebdevelopersbuildmoreenergy
| Thereisalargebodyofworkfocusingonenergyconsumption |     |     |                       |     |           | efficientsites. |                  |     |     |        |       |     |             |
| -------------------------------------------------- | --- | --- | --------------------- | --- | --------- | --------------- | ---------------- | --- | --- | ------ | ----- | --- | ----------- |
| andnetworkactivityinmobiledevices.                 |     |     | Mostresultsfocusonthe |     |           |                 |                  |     |     |        |       |     |             |
|                                                    |     |     |                       |     |           | Designing       | energy-efficient |     | web | sites. | Based | on  | our experi- |
| phoneoperatingsystemorgenericphoneapplications.    |     |     |                       |     | Tothebest |                 |                  |     |     |        |       |     |             |
ments,webrieflysummarizeafewguidelinesfordesigningenergy-
| of our knowledge, |     | none study | the web browser | and | the energy |     |     |     |     |     |     |     |     |
| ----------------- | --- | ---------- | --------------- | --- | ---------- | --- | --- | --- | --- | --- | --- | --- | --- |
efficientwebsites:
neededtorenderspecificpages.
• OurexperimentssuggestthatJPEGisthebestimageformatfor
Networktrafficforsmartphoneapplications. Existingresearch theAndroidbrowserandthisholdsforallimagesizes.
onmobiledeviceshasproposedseveralapproachestotheproblem
|               |        |              |         |            |         | • Gmail, | the | most “green” | mobile |     | site we | found, | uses HTML |
| ------------- | ------ | ------------ | ------- | ---------- | ------- | -------- | --- | ------------ | ------ | --- | ------- | ------ | --------- |
| of minimizing | energy | consumption, | such as | [18] which | reduces |          |     |              |        |     |         |        |           |
linkstoopenemailmessagesthattheuserclickson.Thedesk-
| power consumption |     | of data | transfers, [10] | which chooses | wire- |                                         |     |     |     |     |     |                |     |
| ----------------- | --- | ------- | --------------- | ------------- | ----- | --------------------------------------- | --- | --- | --- | --- | --- | -------------- | --- |
|                   |     |         |                 |               |       | topversionofGmailusesJavascriptinstead. |     |     |     |     |     | Ourexperiments |     |
lessinterfacesbasedonnetworkconditionestimation,[11]which
suggestthatusinglinksinsteadofJavascriptgreatlyreducesthe
| proposes an | approach | to energy-aware | cellular | data | scheduling, |                            |     |     |     |                           |     |     |     |
| ----------- | -------- | --------------- | -------- | ---- | ----------- | -------------------------- | --- | --- | --- | ------------------------- | --- | --- | --- |
|             |          |                 |          |      |             | renderingenergyforthepage. |     |     |     | Thus,bydesigningthemobile |     |     |     |
and[19,9]whichdynamicallyswitchesbetweenwirelessnetwork
|                                  |     |     |                           |     |     | version | of the | site differently |     | than | its desktop | version, | Gmail |
| -------------------------------- | --- | --- | ------------------------- | --- | --- | ------- | ------ | ---------------- | --- | ---- | ----------- | -------- | ----- |
| interfacesbasedonthedatatraffic. |     |     | Severaltechniqueshavebeen |     |     |         |        |                  |     |      |             |          |       |
wasabletosaveenergyonthephone.
| used (e.g., | bundling | multiple | transfers [18], | switching | between |     |     |     |     |     |     |     |     |
| ----------- | -------- | -------- | --------------- | --------- | ------- | --- | --- | --- | --- | --- | --- | --- | --- |
WiFiand3Gcellularnetworks[19,9],andschedulingbasedona • Wefoundanumberofstaticpagesthatcouldhavebeenlocally
dynamicprogrammingprocedureforcomputingtheoptimalcom- cached and displayed without any network access. Unfortu-
munication schedule [11]) to minimize energy consumption. In nately, these sites link to Google Analytics, a tool that helps
49

WWW 2012 – Session: Mobile Web Performance April 16–20, 2012, Lyon, France
monitorsiteusage.JavascriptusedbyGoogleAnalyticsforces [6] SkyFire.http://skyfire.com.
adynamicnetworkrequestthatcannotbecached. Thus,even [7] TheOperabrowser.http://opera.com.
thoughthesitecouldhavebeenrenderedfromcache,thephone [8] WebKit.http://webkit.org.
still has to pay the high cost of setting up a 3G session. We [9] A.Rahmati,C.Shepard,A.Nicoara,L.Zhong,J.Singh.MobileTCP
hopethispaperwillhelpwebsitesunderstandthecostoflink- UsageCharacteristicsandtheFeasibilityofNetworkMigration
withoutInfrastructureSupport.InProc.ofACM16thInternational
ingtothesethirdpartytools.Alternatively,ifbrowsersexposed
ConferenceonMobileComputingandNetworking(MobiCom’10),
thestateoftheradiotoJavascriptthenGoogleAnalyticscould
Chicago,Illinois,USA,2010.
choosenottoreportusageifthe3Gradioisinlow-powermode.
[10] A.Rahmati,L.Zhong.Context-for-Wireless:Context-Sensitive
Energy-EfficientWirelessDataTransfer.InProc.ofACM5th
• AOLisabletosaverenderingenergybyusingasimpleHTML
InternationalConferenceonMobileSystems,Applications,and
tableelementtopositionelementsonthepage.Othersitesthat Services(MobiSys’07),PuertoRico,2007.
positionelementsusingCSSneedfarmoreenergytorender. [11] A.Schulman,V.Navda,R.Ramjee,N.Spring,P.Deshpande,C.
Grunewald,K.Jain,V.N.Padmanabhan.Bartendr:APractical
• OnallthemobilesiteswetestedadsweresmallJPEGfilesand ApproachtoEnergy-awareCellularDataScheduling.InProc.of
hadlittleimpactonoverallpowerusage. ACM16thAnnualInternationalConferenceonMobileComputing
andNetworking(MobiCom’10),Chicago,USA,2010.
• Siteslikeapple.comareparticularlyenergyhungry. Wehope [12] Byung-GonChun,PetrosManiatis.AugmentedSmartphone
this paper demonstrates the importance of building a mobile ApplicationsThroughCloneCloudExecution.InProc.ofthe12th
site optimized for mobile devices. Sites who do not, end up ConferenceonHotTopicsinOperatingSystems,2009.
draining the battery of visiting phones. This can potentially [13] E.Cuervoy,A.Balasubramanian,D-k.Cho,A.Wolman,S.Saroiu,
R.Chandra,P.Bahl.MAUI:MakingSmartphonesLastLongerwith
reducetraffictothesite.
CodeOffload.InProc.ofACM8thIntl.Conf.onMobileSystems,
Applications,andServices(MobiSys’10),SanFrancisco,USA,2010.
Futurework.Ourexperimentsfocusedontheenergyconsumption [14] G.C.Hunt,M.L.Scott.TheCoignAutomaticDistributed
ofspecificpageswiththegoalofimprovingtheenergysignature PartitioningSystem.InProc.ofthe3rdSymposiumonOperating
ofthosepages. Itwouldbeinterestingtoextendtheseresultsand SystemsDesignandImplementation(OSDI’99),Louisiana,1999.
study the energy signature of an entire browsing session at a site [15] J.Flinn,D.Narayanan,M.Satyanarayanan.Self-TunedRemote
ExecutionforPervasiveComputing.InProc.ofthe8thWorkshopon
where the user moves from page to page at that site. During the
HotTopicsinOperatingSystems(HotOS),Germany,2001.
session,webelementssuchasCSSandimageswillbecachedlo-
[16] J.Flinn,S.Park,M.Satyanarayanan.BalancingPerformance,
cally. Therefore, wecannotestimatetheenergycostofasession Energy,andQualityinPervasiveComputing.InProc.ofthe22nd
by simply summing the energies of pages visited during the ses- InternationalConferenceonDistributedComputingSystems
sion. Measuring an entire typical session may help optimize the (ICDCS’02),Vienna,Austria,2002.
powersignatureoftheentirewebsite. [17] J.Huang,Q.Xu,B.Tiwana,A.Wolman,Z.M.Mao,M.Zhang,P.
Anotherinterestingdirectionistomoreaccuratelymodeltheen- Bahl.AnatomizingApplicationPerformanceDifferenceson
Smartphones.InProc.ofACM8thIntl.Conf.onMobileSystems,
ergyconsumptionofthe3Gradioasthebrowserfetcheswebpages.
Applications,andServices(MobiSys’10),SanFrancisco,USA,2010.
OurmodelfromSection2.5workswellforwebpageswithalim-
[18] N.Balasubramanian,A.Balasubramanian,A.Venkataramani.
itednumberofcomponents,butbreaksdownforotherpages. We
EnergyConsumptioninMobilePhones:AMeasurementStudyand
conjecture that a detailed understanding of the shape of the traf- ImplicationsforNetworkApplications.InProc.ofACMSIGCOMM
ficgeneratedbythebrowserwillbeneededtoestimatetheenergy InternetMeasurementConference(IMC’09),Chicago,USA,2009.
usedbytheradio. Understandinghowtheradioisusedwhenthe [19] S.Nirjon,A.Nicoara,C.Hsu,J.Singh,J.Stankovic.MultiNets:
browserfetchesawebpagecouldhelpbrowservendorsoptimize PolicyOrientedReal-TimeSwitchingofWirelessInterfaceson
MobileDevices.InProc.of18thIEEEReal-TimeandEmbedded
thebrowser’smulti-threadedsystemfordownloadingpages.
TechnologyandApplicationsSymposium(RTAS’12),China,2012.
[20] S.Osman,D.Subhraveti,G.Su,J.Nieh.TheDesignand
Acknowledgments
ImplementationofZap.InProc.ofthe5thSymposiumonOperating
SystemsDesignandImplementation(OSDI’02),Boston,USA,2002.
ThefourthauthorwassupportedbyDeutscheTelekomandNSF.
[21] U.Kremer,J.Hicks,J.M.Rehg.Compiler-DirectedRemoteTask
ExecutionforPowerManagement.InProc.ofTheWorkshopon
8. REFERENCES CompilersandOperatingSystemsforLowPower(COLP),2000.
[1] Agilent34410ADigitalMultimeter.http://www.home.agilent. [22] Y.Weinsberg,D.Dolev,T.Anker,M.Ben-Yehuda,P.Wyckoff.
com/agilent/product.jspx?pn=34410A. TappingintotheFountainofCPUs-OnOperatingSystemSupport
[2] AndroidDeveloperPhone2(ADP2). forProgrammableDevices.InProc.ofthe13thInternationalConf.
http://developer.htc.com/google-io-device.html. onArchitecturalSupportforProgrammingLanguagesand
[3] AndroidDevelopers-Activity.http://developer.android. OperatingSystems(ASPLOS’08),Seattle,WA,USA,2008.
com/reference/android/app/Activity.html. [23] Z.Zhuang,K.Kim,J.Singh.ImprovingEnergyEfficiencyof
[4] AndroidDevelopers-Intents.http://developer.android.com/ LocationSensingonSmartphones.InProc.ofACM8thIntl.Conf.on
reference/android/content/Intent.html. MobileSystems,Applications,andServices(MobiSys’10),San
[5] NetMarketShare.http://www.netmarketshare.com/report. Francisco,USA,2010.
aspx?qprid=61&sample=37.
50

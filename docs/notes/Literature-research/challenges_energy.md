Received29June2025,accepted24July2025,dateofpublication6August2025,dateofcurrentversion12August2025.
DigitalObjectIdentifier10.1109/ACCESS.2025.3596459
Challenges Related to Approximating the
Energy Consumption of a Website
JANNEKALLIOLA 1,2 ANDJUHOVEPSÄLÄINEN 3
1DepartmentofInformationandCommunicationsEngineering,SchoolofElectricalEngineering,AaltoUniversity,00076Espoo,Finland
2Exove,00180Helsinki,Finland
3DepartmentofComputerScience,SchoolofScience,AaltoUniversity,00076Espoo,Finland
Correspondingauthor:JanneKalliola(janne.j.kalliola@aalto.fi)
ThisworkwassupportedbyFinElib,Finland,throughtheFinELibconsortium’sagreementwithIEEE.
ABSTRACT Based on a rough estimate, the ICT industry consumes 7 to 10% of the world’s energy, and
around 70% of this is related to usage while the rest can be considered embodied due to manufacturing,
logistics,andrelatedactivities.Simultaneously,thewebhasbecomeanimportantchannelforconsumingICT
servicesasitisthelargestavailableapplicationplatformglobally.Especiallyenergyconsumptionofmobile
webapplicationshasbeenstudiedindetail,butthereisaclearresearchgapforwebapplicationsbecause
suitablemeasurementtoolinghasnotbeenavailableearlier.Thepurposeofthisarticleistoreviewthecurrent
stateoftheartandunderstandhowtoapproximatetheenergyconsumptionofwebapplicationseffectively
by measuring an existing website that has been implemented with two different web frameworks—Qwik
andNext.js.Ourmainfindingsindicatethatalthoughservicesthatapproximateenergyconsumptionofweb
applicationsexist,theytendtooverestimateconsumptionwhencomparedtoourmeasurementsandtheymay
evenshowcontradictoryresultsbetweendifferentwebframeworks.Further,wefoundthatFirefoxProfiler
canbeusedtomeasureenergyconsumptionwithhighprecision.WealsofoundthatWebsiteCarbonservice
fails to acknowledge techniques, such as lazy rendering, and there were open questions related to hosting
detection (green or not) while the service was not transparent in calculating the results—not disclosing
intermediaryresultsorexposingthescopeofthecalculation.OurkeyrecommendationistouseCPU-based
measurementmethodsinestimatingwebenergyconsumption.
INDEX TERMS Green computing, web development, benchmarking, energy consumption, software
development.
I. INTRODUCTION estimationmethodemployed.Totranslateconsumptionintoa
Introduced in the early 90s [1], the web now reaches figure,thatmeansconsumptionofupto2.34PWhyearly[5],
two-thirds of the global population [2] these days making which is almost the electricity production of the European
it the largest available application platform. Although not Union2022(2.64PWh)[6].
originally designed as such [3], the web has become so Freitag et al. [7] approximate that the emissions were
over decades of development as new fields, for example, between2.1%and3.9%ofglobalemissionsin2020.About
e-commerce and social networking, have evolved on top of 70% of these emissions are from the use phase and 30%
it to create new wealth and value on top of the internet are embodied emissions from equipment manufacturing,
connectingtheworld.Thegrowthofthewebhasbroughtnew logistics,andothersimilaractivities.Thefocusofthisstudy
challenges to consider as the web consumes a considerable isonusephaseenergyconsumptionwhichcanbeconverted
amountofenergy. toemissions.
Whileglobalenergyconsumptionisgrowingat1–2%per
A. GLOBALENERGYCONSUMPTIONOFICTANDTHE
year[8],theannualgrowthratesofICTenergyconsumption
WEB
Ojala et al. estimate [4], that the ICT industry consumes between 2015 and 2022 have been estimated at 2.7–7.9%
between7and10%oftheworld’senergy,dependingonthe for data centers and 2.4–7.3% for data networks [9]. The
International Energy Agency recommends improving data
The associate editor coordinating the review of this manuscript and collectionandtransparency,collectingandreportingenergy
approvingitforpublicationwasDerekAbbott . usedata,andcommittingtoefficiencyinICT[9].
2025TheAuthors.ThisworkislicensedunderaCreativeCommonsAttribution4.0License.
VOLUME13,2025 Formoreinformation,seehttps://creativecommons.org/licenses/by/4.0/ 139001

J.Kalliola,J.Vepsäläinen:ChallengesRelatedtoApproximatingtheEnergyConsumptionofaWebsite
Due to renewable energy production continues to grow totheirabilitytodirectlyinteractwiththesystem’shardware
at a faster rate than any other energy source, the share andmakeoptimizeduseofsystemAPIs.
WebsiteCarbonCalculator3andEcograder4providerecent
| of non-fossil | | fuels is | estimated | to | increase | from | 21% to | | | | | | | | |
| ------------- | --- | -------- | --------- | --- | -------- | ---- | ------ | --- | --- | --- | --- | --- | --- | --- | --- |
29%–34%in2050[10,p.12].Nevertheless,thisgrowthwill examplesofwebservicesthatgiveaneasyapproximationof
not be sufficient to meet the energy demand. Consequently, theenergyconsumptionofwebsites,andwewilldemonstrate
the use and, therefore, the carbon emissions of liquid fuels WebsiteCarbonCalculatorlaterinthisarticle.
and natural gas are expected to increase [10, p. 15]. The There is a good amount of prior research on energy
United Nations has identified the generation of electricity consumption, especially in mobile context [16], [19], [20],
and heat from fossil fuels as one of the primary causes of [21], [22]. However, the amount of studies focused on the
climate change [11]. The main drivers of global electricity energy consumption of web applications seems severely
demandincreaseareelectricvehicles,heatpumps,anddata limitedalthoughrelatedwebserviceshavebecomeavailable
centers[12,p.15]. in recent years and the topic has gained relevance due to
Globally,theaverageuserconsumes3,230hoursofdigital increasedawareness.
| content | annually, | comprising | | 730 | hours | of web | browsing | | | | | | | | |
| ------- | --------- | ---------- | --- | --- | ----- | ------ | -------- | --- | --- | --- | --- | --- | --- | --- | --- |
(22.6%),894hoursofsocialmediausage(27.7%),833hours C. RESEARCHQUESTIONS
of video streaming (25.8%), 566 hours of music streaming Although the energy consumption of the web can be
| (17.5%), | and | 207 hours | of | video | conferencing | | (6.4%) as | | | | | | | | |
| -------- | --- | --------- | --- | ----- | ------------ | --- | --------- | ---------- | --- | ------- | ------------ | --- | ---------- | --------- | --- |
| | | | | | | | | understood | on | a large | scale, there | are | still open | questions | |
per [13]. Video streaming has the highest lifecycle impact relatedtoitscompositionandhowtomeasureiteffectively.
| (40–52%) | in | all categories, | | while | web surfing | | and social | | | | | | | | |
| -------- | --- | --------------- | --- | ----- | ----------- | --- | ---------- | ---------- | ----- | --------- | --- | ---- | ------- | ------------ | --- |
| | | | | | | | | To address | these | concerns, | we | have | defined | our research | |
media have the second and third highest impact (10–18%) questionsasfollows:
| in most | categories. | Therefore, | | limiting | the | impact | of these | | | | | | | | |
| ------- | ----------- | ---------- | --- | -------- | --- | ------ | -------- | ------- | ---- | ------- | ------- | ------------ | --- | ------ | ------ |
| | | | | | | | | 1) RQ1: | What | are the | factors | contributing | | to the | energy |
activitieswouldreducethenegativeeffectsrelatedtoenergy
usageoftheweb?
production.
| | | | | | | | | 2) RQ2: | How | is it | possible | to | measure | the | energy |
| --- | --- | --- | --- | --- | --- | --- | --- | ------- | --- | ----- | -------- | --- | ------- | --- | ------ |
consumptionofthewebatthemomentusingavailable
B. FEWPRIORSTUDIESFOCUSINGONTHEENERGY
tools?
CONSUMPTIONOFWEBAPPLICATIONSEXIST
| | | | | | | | | Therefore, | the | target | is to | deepen | the understanding | | |
| --- | --- | --- | --- | --- | --- | --- | --- | ---------- | --- | ------ | ----- | ------ | ----------------- | --- | --- |
In[14]from2015,Koretal.usednowdeprecatedJoulemeter
| | | | | | | | | of the energy | | consumption | of | the web | while | motivating | |
| --- | --- | --- | --- | --- | --- | --- | --- | ------------- | --- | ----------- | --- | ------- | ----- | ---------- | --- |
software1toapproximatetheenergyconsumptionofrunning
furtherresearchonthetopic.Inthiscontext,weconcentrate
| videos | in different | | web browsers | | in desktop | | (Windows) | | | | | | | | |
| ---------- | ------------ | ------------- | ------------ | --- | ---------- | -------- | --------- | ------------ | --- | ----------- | ---- | ----------- | --- | ------------ | --- |
| | | | | | | | | specifically | on | the initial | load | performance | of | the frontend | |
| and mobile | (iOS) | environments. | | Kor | et | al. [14] | found the | | | | | | | | |
whileleavingdynamicusageoutofthepicture.
| differences | between | | the energy | consumption | | of | browsers | | | | | | | | |
| ----------- | ------- | --- | ---------- | ----------- | --- | --- | -------- | --- | --- | --- | --- | --- | --- | --- | --- |
occurmainlyduetoCPUusageforthisparticularusecase.
D. STRUCTUREOFTHEARTICLE
| Huber | et al. | in [16] | investigated | | the energy | consumption | | | | | | | | | |
| ----- | ------ | ------- | ------------ | --- | ---------- | ----------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
ofProgressiveWebApps(PWAs)thatallowmobile-likeuser Weapproachtheresearchproblemsbyfirsthighlightingthe
| | | | | | | | | main technical | | trends | of the | web in | Section | II and | then |
| --- | --- | --- | --- | --- | --- | --- | --- | -------------- | --- | ------ | ------ | ------ | ------- | ------ | ---- |
experiencesforwebapplicationsthroughtheuseofspecific
| | | | | | | | | investigating | the | current | state of | energy | consumption | | of the |
| ----------- | --- | ---------- | --------- | --- | ------ | --- | --------- | ------------- | --- | ------- | -------- | ------ | ----------- | --- | ------ |
| programming | | techniques | available | | on the | web | platform. | | | | | | | | |
webinSectionIIIbeforeperforminganempiricalstudysplit
| Huber | et al. [16] | found | that | PWAs | consume | slightly | more | | | | | | | | |
| ------ | ------------ | ----- | ------------ | ---- | ------- | -------- | ---------- | -------------- | --- | ---------- | ----- | ------- | --- | ----------- | --- |
| | | | | | | | | to two phases: | | in Section | IV we | measure | the | consumption | |
| energy | than regular | web | applications | | but | despite | this offer | | | | | | | | |
a good option to native mobile applications as they allow of a web page from the perspective of the user while in
| | | | | | | | | Section V | we | measure | the same | pages | using | a data-based | |
| --- | --- | --- | --- | --- | --- | --- | --- | --------- | --- | ------- | -------- | ----- | ----- | ------------ | --- |
thedevelopmentofmulti-platformsoftwarethroughasingle
carboncalculator.Thesetwoperspectivesarethencompared
codebase.Tomeasureenergyconsumption,Huberetal.[16]
batterystats inSectionVIbeforeconsideringourfindingsinSectionVII
| used | Android | UI Automator | | and | | | service | | | | | | | | |
| ---- | ------- | ------------ | --- | --- | --- | --- | ------- | --- | --- | --- | --- | --- | --- | --- | --- |
andfinallyconcludinginSectionVIII.
availableontheAndroidplatform.
Saarinenetal.[17]studiedthedatauseof10,000popular
II. THECURRENTTECHNICALTRENDSOFTHEWEB
| websites | and | found | that it | would | be possible | | to achieve | | | | | | | | |
| -------- | --- | ----- | ------- | ----- | ----------- | --- | ---------- | --- | --- | --- | --- | --- | --- | --- | --- |
significant energy savings on the server side and mobile The evolution of the web could be characterized as a
| | | | | | | | | pendulum | between | the | server | and the | client. | The web | was |
| -------- | ------------- | --- | --------- | --- | ------ | --- | ---------- | ------------ | ------- | -------------- | ------ | --------- | ------- | ------- | ---- |
| networks | by optimizing | | the usage | of | images | and | JavaScript | | | | | | | | |
| | | | | | | | | not designed | as | an application | | platform, | but it | became | such |
asbothcontributedroughly78%tothetotalsizeofthesites.
In[18],Thangaduraietal.comparedtheenergyefficiency over time, and solutions, such as Electron, allow wrapping
Electron2 web applications as desktop ones allowing multi-platform
| of | applications | | and | web-based | applications | | in the | | | | | | | | |
| --- | ------------ | --- | --- | --------- | ------------ | --- | ------ | --- | --- | --- | --- | --- | --- | --- | --- |
contextofremotecollaboration.Electron-basedapplications development.Thisdevelopmenthasledtoasituationwhere
| | | | | | | | | web frameworks | | address | features | missing | from | the | web |
| ---- | -------- | ------- | ----------------- | --- | ---- | -------- | --- | -------------- | ----------- | ------- | --------------- | ------- | ---- | --------- | --- |
| were | found to | be more | energy-efficient, | | most | probably | due | | | | | | | | |
| | | | | | | | | platform. | Eventually, | web | standardization | | has | been able | to |
1Similar
| | energy | measurement | capability | | is available | in | Visual Studio | | | | | | | | |
| --- | ------ | ----------- | ---------- | --- | ------------ | --- | ------------- | --- | --- | --- | --- | --- | --- | --- | --- |
3https://www.websitecarbon.com/
now[15].
| 2https://www.electronjs.org/ | | | | | | | | 4https://ecograder.com/ | | | | | | | |
| ---------------------------- | --- | --- | --- | --- | --- | --- | --- | ----------------------- | --- | --- | --- | --- | --- | ------------- | --- |
| 139002 | | | | | | | | | | | | | | VOLUME13,2025 | |

J.Kalliola,J.Vepsäläinen:ChallengesRelatedtoApproximatingtheEnergyConsumptionofaWebsite
integrate ideas from the framework space to the platform E. CONTINUINGGROWTHOFTHEWEBSITES
itselfalthoughwebframeworksarestillwidelyused. It is difficult to give an exact estimate on how many
websitesarewebapplications.Oftenawebsitemightinclude
A. HEADLESSARCHITECTURE application-like functionality in a part, while others might
A recent development within websites is the advent of a resemble the traditional, static web. However, it is well
headless architecture, which decouples the web experience understoodthatthesizeofwebsiteshasincreasedandfuture
layerinbrowsersfromdataandbusinesslogic[23],[24].The projections indicate that this trend will continue [34], [35],
concept designated JAMStack, was introduced by Biilmann [36].Ithasbeenestimatedthatbrowsingthewebin2030will
at SmashingConf in 2016 [25]. In JAMStack, the backend consume1GBofdataperhourperuser[36,p.8].
is entirely distinct from the presentation layer, with content Thesizeofwebsiteslikelykeepsgrowingas[37]pointed
accessed through REST API or GraphQL and rendered in out that the median size of websites on mobile grew nearly
HTMLinthebrowserusingawebframework[26],making 600%between2012and2022.Thesizeitselfleadstomore
websitesworkaswebapplications. processingandconsumptionofresourcesacrossthedifferent
portions of infrastructure and gives a leading figure telling
about the general trend and highlighting the urgency of the
B. PROSANDCONSOFWEBFRAMEWORKS
problem.
Although web frameworks have made it easier to develop
A study conducted by Saarinen and Manner [38] in
complex web applications, they also come with caveats
2022 analyzed the thousand most popular websites in
related to energy consumption. By definition, a framework
Finland. One of the key findings was that only 2.0% of the
providesadeveloperstructureandpredefinedsolutions[27].
transferred data was in the HTML format—that carries the
Furthermore,frameworksconstrainhowapplicationsmaybe
human-readable information—while static files, including
developed by favoring certain solutions over others. There-
images, videos, fonts, downloadable files, JavaScript and
fore, the ideas embedded within a framework affect energy
CSS code, accounted for 91.7%. The remaining data were
consumption.Giventhecurrentmainstreamframeworkshave
either uncategorized (1.4%) or XHR (4.5%) downloads.
a strong focus on Developer eXperience (DX) [28], it is
These figures are derived from the ‘‘scrolled computer’’
possibletheymaynotbethemostenergyefficient.
category, which encompasses web pages that are fully
scrolleddownonacomputer.
C. RISEOFDISAPPEARINGFRAMEWORKS
So-called disappearing frameworks [28], [29] address the
F. HOWTOADDRESSTHEGROWTHOFWEBSITES?
problem by approaching the problem by trying to minimize
Saarinen et al. [17] noted that the size of websites could
the impact of the framework from the code delivered to
bedecreasedsignificantlybyfocusingonoptimizingimages
the client. It was common to deliver heavy JavaScript
and the usage of JavaScript as both contribute around 78%
payloads in earlier approaches for the client to hydrate5
of website size. As early as 2010, Hirsch-Dick et al. [39]
leading to additional work although this was convenient for
developedasetoftwelveprinciplesfortheenvironmentally
developers[31].
sustainabledevelopment,maintenance,anduseofwebsites.
The principles by Hirsch-Dick et al. [39] are designed to
D. NEXT.JSANDQWIK catertothreedistinctusergroups:
Both Next.js and Qwik are examples of recent JavaScript
Websiteadministrators
frameworks meant for the development of websites and
Configuresupportforcaching,utilizecompression,
applications and we will use them in our benchmarks later
andapplygreenITconcepts.
in Section IV. Next.js could be characterized as a full-stack
Developers,designers,andcontentauthors
JavaScript framework for React that allows developers to
Ensure caching support, minimize the amount of
engineerwholeapplicationsusingit[32].Inthisway,Qwik
JavaScript, minimize and optimize the used CSS,
is similar to it, although Qwik represents a paradigm-level
and optimize graphical elements, such as logos,
shift for web frameworks due to its unique approach based
photos,videos,andanimations.
on resumability [28] making it a disappearing framework.
Users
Resumability allows Qwik to take advantage of the idea of
Haveproperlyconfiguredbrowsers.
code splitting [33] at a highly granular level while letting
The growth of websites could be hindered using these
Qwikloaddatadirectlyfromthemarkup,thusavoidingthe
principlesasillustratedbyFahlströmandPersson[40]intheir
doubleworkassociatedwithhydration[31].
thesisfrom2023,wheretheycreatedtwoversionsofaweb
page. The first was based on the typical traits of websites
analyzed in the thesis, while the second was created using
sustainable web design principles. The initial page weighed
5Hydration is required to turn the client page interactive by applying
7.83MB,whereasthesubsequentsecondpageweighedonly
JavaScript logic where it is needed [30]. New techniques, such as
resumability[31],removethisrequirement. 1.42MB[40].
VOLUME13,2025 139003

J.Kalliola,J.Vepsäläinen:ChallengesRelatedtoApproximatingtheEnergyConsumptionofaWebsite
G. REFLECTION as the most impactful action in reducing the environmental
impactofawebsite.
| Web browsing | is | one of | the largest | segments | (22.6%) of | | | | | | |
| ------------ | ------- | ------- | ----------- | -------- | ---------- | --- | --- | --- | --- | --- | --- |
| consuming | digital | content | [41]. The | websites | have been | | | | | | |
growingsteadilyovertheyearsbothinsizeandincomplexity.
B. EARLIERWORKONTHEENERGYCONSUMPTIONOF
| Thecompositionofthewebsiteshaschangedinrecentyears | | | | | | THEWEB | | | | | |
| -------------------------------------------------- | ---------- | ----- | ----- | --------------- | ------- | ------ | -------- | ------ | ----------------- | -------- | -------- |
| and more | processing | takes | place | in the consumer | device. | | | | | | |
| | | | | | | There | has been | little | recent scientific | research | into the |
These developments increase the energy consumption and energy efficiency of websites. However, several approaches
emissions of web browsing. There are concepts and best to estimating energy consumption or emissions have been
practicesavailabletoreducetheadverseeffectsofwebsites.
| | | | | | | created, | such | as using | Cloud Carbon | Footprint, | measuring |
| --- | --- | --- | --- | --- | --- | -------- | ---- | -------- | ------------ | ---------- | --------- |
Theireffectivenessonthewebsitesizeshasbeenmeasured, computing required of HTML elements and CSS selectors,
| but the impact | on | energy | consumption | and | emissions is not | | | | | | |
| -------------- | --- | ------ | ----------- | --- | ---------------- | --- | --- | --- | --- | --- | --- |
usingFirefoxProfiler,orusingGoogleLighthouseresultsas
| clear. | | | | | | aproxy. | | | | | |
| ------ | --- | --- | --- | --- | --- | ------- | --- | --- | --- | --- | --- |
Irani[51]hasproposedamodelforestimatingtheenergy
III. THECURRENTSTATEOFMEASURINGENERGY consumption of website servers based on the Cloud Carbon
Footprint(CCF)model.Themodel’sscopeisbasedonfour
CONSUMPTIONOFTHEWEB
| To understand | the | impact | of the transformation | | of website | parameters: | | | | | |
| ------------- | --- | ------ | --------------------- | --- | ---------- | ----------- | --- | --- | --- | --- | --- |
developmentandthegrowthofthegeneratedandtransferred
Compute
data,thewebsiteenergyconsumptionshouldbemeasurable. Energyconsumedbyservercomputationstodeliver
Themeasurementshouldpreferablybeeasytousesothatit
awebpage.
| canbeincorporatedintothewebsitedevelopmentprocess. | | | | | | Storage | | | | | |
| -------------------------------------------------- | --- | --- | --- | --- | --- | ------- | --- | --- | --- | --- | --- |
Energyexpendedtostorethewebpage.
| A. MEASURINGWEBSITEENERGYCONSUMPTION | | | | | | Networking | | | | | |
| ------------------------------------ | -------- | ------------ | ----------- | --- | ------------- | ---------- | ------ | -------- | ---------------- | ------- | ------- |
| | | | | | | | Energy | required | for the transfer | of data | between |
| As stated | earlier, | web browsing | constitutes | | almost 23% of | | | | | | |
digital content consumption [41], the sizes of websites are datacenters.
Memory
| constantly | growing, | and sustainable | | choices | would reduce | | | | | | |
| ---------- | -------- | --------------- | --- | ------- | ------------ | --- | --- | --- | --- | --- | --- |
Energyutilizedbyservermemorytodeliveraweb
| the size | of the | sites drastically. | | Technological | choices | | | | | | |
| --------------------------------------------------- | ------ | ------------------ | --- | ------------- | ------- | --- | ----- | --- | --- | --- | --- |
| affectenergyconsumption.Forexample,theperformanceof | | | | | | | page. | | | | |
contentmanagementsystemsthatareemployedby68.5%of Regrettably,thecalculationofsuchparametersisbasedon
websites [42] has several implications, which are typically assumptionsoraveragevaluesduetothelackoruncertainty
measured using a variety of indicators. These include the ofdataavailable.
size of the generated page, as well as the delay between AnalternativeapproachistomeasuretheCPU,GPU,and
a browser request and a server response [43], [44]. The RAMusageofHTMLdocumentelementsandCSSselectors,
headlesswebsiteparadigmchangestheenergyconsumption as well as other assets employed in the composition of a
distribution between the back-end (content management web page, as discussed by Dawson in [52]. The results of
systemsorsimilar)andfrontend(browsers)[45]. thestudyfacilitateamoreprecisemeasurementofwebpage
Inadditiontotechnologicalchoices,theenergyconsump- energyconsumption;however,itisunfortunatethatitfocuses
tionandcarbonemissionsofwebpagesarecontingentupon solely on the more static assets such as HTML and CSS
the content itself [46]. Although the energy consumption of and excludes JavaScript and server-side generation due to
networks is largely inelastic [47], the content management inherent difficulties in analyzing their energy consumption.
systems must perform more or longer database and storage As previously stated in [38], only 2.0% of the web data is
operations to retrieve larger or more complex content. This HTMLand2.7%isCSS,whileJavaScriptrepresents22%.
also applies to the browser that renders the content to the AstudyconductedbyChan-Jong-Chuetal.[53]revealed
user, particularly in instances where the content contains that the performance scores of Google Lighthouse can be
animations or the user is required to navigate the page utilized as an indicator of the potential energy consumption
extensively, resulting in the browser having to redraw the of a specific web application. Notably, significant energy
content[48].Furthermore,thetypeofcontent,suchasvideo consumption reductions can be achieved when a web
ortext,hasanimpactonemissions[49,p.16]. application is optimized from poor level to average-good
AsurveyconductedbyTutt[50]forSearchEngineLand levelofperformance.
revealedthat33%oftherespondentshaveutilizedawebsite Web application performance and energy efficiency were
carboncalculatortoestimatethecarbonemissionsassociated measured by Thangadurai et al. [18] in the context
with a particular website. The same survey identified a of remote communication and collaboration by assessing
lack of awareness regarding the environmental impact of Electron-basedcommunicationappsagainsttheirweb-based
websites as the primary reason for the limited development implementations. Their measurements demonstrated differ-
of more sustainable websites and also revealed that 51% of ences in energy consumption and CPU utilization, but the
the respondents identified the adoption of a green web host resultsareboundtothedomainofremotecommunication.
| 139004 | | | | | | | | | | | VOLUME13,2025 |
| ------ | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ------------- |

J.Kalliola,J.Vepsäläinen:ChallengesRelatedtoApproximatingtheEnergyConsumptionofaWebsite
TABLE1. Thetabledisplaysvariousmeasurementtoolsandtheirrespectivemethodologiesincludingadditionalnotes.
C. EXISTINGMEASUREMENTTOOLS data from Ember and the United Nations Framework
| | | | | | Convention | on Climate Change. | At present, | peer-reviewed |
| ------- | ---------------- | --------- | ---------------- | --- | ---------- | ------------------ | ----------- | ------------- |
| Several | online tools are | available | for the analysis | and | | | | |
estimation of energy consumption and carbon emissions carboncalculationmodelsareavailable:theSustainableWeb
associated with a web page or website. The following tools DesignmodelandtheOneByte(‘‘1byte’’)model.
| | | | | | These models | yield differing | estimates | of carbon emis- |
| --- | --- | --- | --- | --- | ------------ | --------------- | --------- | --------------- |
werelistedinasustainabilityblogpostpublishedinOctober
2022 [54]: Website Carbon Calculator, Ecograder, Carbon sions, reflecting the fact that they employ disparate system
Calculator,Greenpixie,Beacon,Statsy,Cabin,Ecoping,The boundaries in determining the components included in the
Offset Mode, Carbonanalyser, and GreenFrame. Table 1 calculation[79].Anopenstandardizationprocessiscurrently
characterizes the tools in detail. It should be noted that underway with the various carbon calculator providers to
estimatetheemissionsgeneratedbydigitalservices[56].
| the list of | tools is not | exhaustive | and that Greenpixie | and | | | | |
| ----------- | ------------ | ---------- | ------------------- | --- | --- | --- | --- | --- |
Statsy were omitted as the services were not available The library provides a set of functions to estimate the
anymore. emissions per a transferred byte or a website visit using
| | | | | | the aforementioned | models | [80]. These | functions have |
| --- | --- | --- | --- | --- | ------------------ | ------ | ----------- | -------------- |
D. CO2.JSLIBRARY severalparametersthataffectthecalculation.Unfortunately,
CO2.js7 the online services do not disclose how and with which
| The | library, which | is utilized | by numerous | carbon | | | | |
| --- | -------------- | ----------- | ----------- | ------ | --- | --- | --- | --- |
calculators introduced earlier, is an open-source tool for parameters they use the library, so the exact calculation
remainsopaque.
| assessing | carbon emissions | based | on the volume | of data | | | | |
| --------- | ---------------- | ----- | ------------- | ------- | --- | --- | --- | --- |
transferred and the carbon intensity of the electricity ThelatestiterationoftheSustainableWebDesignModel
used [78]. The library contains the annual grid intensity for estimating digital emissions (July 5th, 2024) [81]
| | | | | | categorizes | the energy consumption | into | three segments, |
| --- | --- | --- | --- | --- | ----------- | ---------------------- | ---- | --------------- |
7https://github.com/thegreenwebfoundation/co2.js/
inalignmentwiththefindingsofMalmodinetal.[82]:
| VOLUME13,2025 | | | | | | | | 139005 |
| ------------- | --- | --- | --- | --- | --- | --- | --- | ------ |

J.Kalliola,J.Vepsäläinen:ChallengesRelatedtoApproximatingtheEnergyConsumptionofaWebsite
• Userdevices:54% withdatatransmissionandcomputingoperations[89],[91].
Networkdatatransfer:24% Additionally, defining the boundaries for the sources of
•
• Datacenteruse:22% calculation is not a straightforward process. For instance,
| | | | | | | | there is a | question | as to | whether | the | costs associated | | with |
| --- | --- | --- | --- | --- | --- | --- | ---------- | -------- | ----- | ------- | --- | ---------------- | --- | ---- |
Eachofthesecategoriesisfurthersubdividedintooperational
and embodied emissions, per the study conducted by building data centers or computing equipment should be
Malmodinetal.[82],asshowninTable2. includedinthecarboncalculationsornot[91].
| | | | | | | | Further | critique | of the | calculation | | method | is based | on |
| ----------- | ------ | ------- | --- | ------ | -------- | --------- | ------- | -------- | ------ | ----------- | --- | ------ | -------- | --- |
| The earlier | model, | version | 3, | uses a | slightly | different | | | | | | | | |
approach to calculate the emissions. Version 3 delineated the use of page weight as a proxy metric, which is easily
measurable,butwhichcannotpredicttheactualemissionsof
| energy consumption | | into | four segments | | [56], | with the | | | | | | | | |
| ------------------ | --- | ---- | ------------- | --- | ----- | -------- | --- | --- | --- | --- | --- | --- | --- | --- |
categorizationbasedonthe‘‘Expected2020scenario’’from awebpage.Forexample,theamountofprocessingrequired
thestudybyAndrae[83]: on the end-user device and the intensity of server-side
processingarenottakenintoaccount[51],[92].
Consumerdeviceuse:52%
•
| | | | | | | | Although | the | calculators | are | based | on a | single | metric |
| --- | --- | --- | --- | --- | --- | --- | -------- | --- | ----------- | --- | ----- | ---- | ------ | ------ |
• Networkdatatransfer:14%
| | | | | | | | and straightforward | | estimations | | that | have little | connection | |
| --- | --- | --- | --- | --- | --- | --- | ------------------- | --- | ----------- | --- | ---- | ----------- | ---------- | --- |
• Datacenteruse:15%
totherealsituation,theydemonstratehighlyprecisecarbon
• Hardwareproductionforallthreecategoriesabove:19%
| | | | | | | | emission | numbers | without | adequately | | disclosing | | that the |
| --------------- | --- | ------ | ---------- | ---- | ------ | --------- | -------- | ------------- | ------- | ---------- | --------- | ---------- | ------------- | -------- |
| Both iterations | | of the | model take | data | center | renewable | | | | | | | | |
| | | | | | | | numbers | are estimates | | only [92]. | Moreover, | | the estimated | |
energysourcesintoaccountwhilecalculatingtheemissions
carbonemissionfigureisemployedtoassignanenergyrating
[56],[84].Thelatestmodelemploysavaluebetween0and
fromA+toFforwebsites[93].
| 1 to indicate | the | proportion | of a | data center’s | | operational | | | | | | | | |
| ------------- | --- | ---------- | ---- | ------------- | --- | ----------- | ----------- | ----- | --- | -------- | --- | --------- | ------------- | --- |
| | | | | | | | In a recent | study | by | Lecorney | et | al. [94], | the following | |
electricitythatisgeneratedthroughrenewablesources[84].
limitationswereidentifiedthroughtheuseofaninvarianttest
webpagetotestseveraldifferentcalculators:
TABLE2. Shareofoperationalandembodiedemissionsofthreedigital
emissionsegments.[82]. 1) Thetoolsinquestionfailtoaccountforvideosaspartof
thecarboncalculation.Insomecases,certainfileswere
| | | | | | | | not | visible | to the | various | tools, | and videos | were | not |
| --- | --- | --- | --- | --- | --- | --- | ----- | ------- | ------- | ------- | -------- | ---------- | ------------ | --- |
| | | | | | | | taken | into | account | when | autoplay | mode | was disabled | |
orwhenthevideowasintegratedthroughYouTube.
| | | | | | | | 2) The | carbon | emission | calculations | | exhibited | | consid- |
| --- | --- | --- | --- | --- | --- | --- | ------------ | --------- | ------------ | ------------ | ---------- | --------- | ---------- | ------- |
| | | | | | | | erable | variation | between | | the tools. | In | the study, | the |
| | | | | | | | calculations | | demonstrated | | a factor | of up | to 27 | for the |
samewebsite.
E. GREENHOSTINGDATABASE 3) Pagesizeestimationsalsoexhibitedconsiderablevari-
| The Green | Web | Foundation | maintains | a | register | of green | | | | | | | | |
| --------- | ----------- | ---------- | ----------- | --- | ------------- | -------- | --------------------------------------------- | --- | --- | --- | --- | --- | --- | --- |
| | providers.8 | | | | | | ation,evenwhenthevideolimitationwasdiscarded. | | | | | | | |
| hosting | | To | be included | on | the register, | the | | | | | | | | | 4) Thetoolsutilizedsolelytheamountoftransferreddata
providermustdemonstratethattheyareavoiding,reducing,
andnumberofrequests,withoutconsiderationofserver
| or compensating | | for carbon | emissions | | [85]. Furthermore, | | | | | | | | | |
| --------------- | ---- | ------------ | --------- | ---- | ------------------ | --- | --- | ----------- | --------- | --- | ------------- | --- | ---- | ------ |
| | | | | | | | or | client-side | rendering | | of the pages, | or | more | power- |
| the evidence | must | be presented | on | time | and demonstrate | a | | | | | | | | |
intensivebackendfunctionalityorAPIservices.
| material | difference. | Typical | solutions | for | inclusion | on the | | | | | | | | |
| -------- | ----------- | ------- | --------- | --- | --------- | ------ | --- | --- | --- | --- | --- | --- | --- | --- |
registerincludetheuseofrenewablegreenenergy,operation
inaregionwithlowelectricitycarbonintensity,oroffsetting G. REFLECTION
thepurchasedenergy[86]. Thereisanurgentneedforamoreenergy-efficientweb,but
Despitethefoundation’sprovisionofcompellingjustifica- therehasbeenlittlerecentscientificresearchintotheenergy
tionsforhostingwebsitesongreenenergyplatforms[85],the efficiencyofwebsites.Whiletherearesomeestimationtools
growthinglobalenergyconsumptionoutpacestheproduction available in the web [54], their estimation models result
ofrenewableenergysources[87,p.15],renderingthegreen in different estimates of carbon emissions due to disparate
hostingrequirementlargelyineffective. system boundaries and varying inclusion of components
| | | | | | | | in the calculation | | [89], | [90]. | Further, | the reliability | | of the |
| --- | --- | --- | --- | --- | --- | --- | ------------------ | --- | ----- | ----- | -------- | --------------- | --- | ------ |
calculationhasbeencalledintoquestionduetousingsingle
F. CALCULATIONRELIABILITY
Thereliabilityofthecarboncalculatorshasbeencalledinto metrics and straightforward estimations that are shown as
question[88],astheyyielddisparateresultsforthesamesite highly precise emission figures without disclosure of them
andtheircalculationmethodologyvariesfromonecalculator beingonlyestimates[92].
to another [89], [90]. This discrepancy can be attributed Thereisapressingneedforreliableandeasy-to-useenergy
| | | | | | | | consumption | and | emission | tools | for | website | development. | |
| ------------------ | --- | ------------ | ------------ | --- | ------- | ---- | ----------- | --- | -------- | ----- | --- | ------- | ------------ | --- |
| to the utilization | | of disparate | coefficients | | derived | from | | | | | | | | |
the studies examining the energy consumption associated The practitioners of the field have tried out some tools and
wouldliketousethemformore[50],butthecurrentstateof
8https://www.thegreenwebfoundation.org/tools/directory/
thetoolingdoesnotseemadequate[92].
| 139006 | | | | | | | | | | | | | VOLUME13,2025 | |
| ------ | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ------------- | --- |

J.Kalliola,J.Vepsäläinen:ChallengesRelatedtoApproximatingtheEnergyConsumptionofaWebsite
IV. MEASUREMENTSONEND-USERDEVICE 1) BrowsercacheisclearedusingClear Cacheplug-
| Theenergyconsumptionofend-userdevicesassociatedwith | | | | | | | in. | | | | | | |
| --------------------------------------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
websites and applications can be quantified through the 2) Powerprofilingisstartedfornon-cachedresults.
utilization of recently developed browser power profiling 3) PageisloadedandscrolleddownusingFoxScroller,
tools.Toserveasanexample,theFirefoxbrowserprovides a scrolling plug-in, with the speed of 300 pixels per
| an energy | profiler for | Windows, | Mac, | and Linux | platforms | | second. | | | | | | |
| --------- | ------------ | -------- | ---- | --------- | --------- | --- | ------- | --- | --- | --- | --- | --- | --- |
[95].TheprofilerqueriesoperatingsystemAPIstorecordthe 4) Powerprofilingisstopped.
energy consumption and provide more detailed information 5) Non-cachedresultsareanalyzed.
than the carbon calculators discussed earlier [96]. Due 6) In a new tab, power profiling is started for cached
| to differences | in operating | | systems | and the | underlying | | results. | | | | | | |
| -------------- | ------------ | --- | ------- | ------- | ---------- | --- | -------- | --- | --- | --- | --- | --- | --- |
hardware, the results are not directly comparable between 7) PageisloadedandscrolleddownusingFoxScroller,
systems,buttheycanbeusedtocompareenergyconsumption aspreviously.
| withinasystem[97]. | | | | | | | 8) Powerprofilingisstopped. | | | | | | |
| ------------------ | --- | --- | --- | --- | --- | --- | --------------------------- | --- | --- | --- | --- | --- | --- |
Firefox Profiler uses operating system-provided power 9) Cachedresultsareanalyzed.
counters to measure CPU energy consumption. Energy To reduce erroneous measurements, this procedure was
consumption is sampled on configured intervals, by default repeated five times. We measured both versions of the site
everymillisecond.Eachsampleisstoredalongthetimestamp
| | | | | | | | using two | different | platforms | and | operating | systems: | Apple |
| --- | --- | --- | --- | --- | --- | --- | --------- | --------- | --------- | --- | --------- | -------- | ----- |
and difference between the counter values at the previous MacBook Pro with Apple M3 Pro processor10 and macOS
andthecurrentsample.Togettheenergyusedoveraperiod
| | | | | | | | Sonoma | 14.7 | operating | system, | and Lenovo | | ThinkPad |
| --- | --- | --- | --- | --- | --- | --- | ------ | ---- | --------- | ------- | ---------- | --- | -------- |
of time, the profiler sums the values of the samples of the E14 Gen 5 with Intel Core i3 processor11 and Windows
period[98]. 11operatingsystem.Toensuresimilarmeasurementsonboth
Tomeasuretheenergyconsumptiononend-userdevices,
| | | | | | | | systems, | the Firefox | window | was | placed maximized | | on a |
| --- | --- | --- | --- | --- | --- | --- | -------- | ----------- | ------ | --- | ---------------- | --- | ---- |
asmall-scaletestsetupwasconfigured.Thissetupwasbased FullHD(1920×1200)externaldisplay,andthelaptopwas
| on two web | frameworks | and | the Firefox | browser. | | In this | | | | | | | |
| ---------- | ---------- | --- | ----------- | -------- | --- | ------- | --- | --- | --- | --- | --- | --- | --- |
connectedtoapowersupply.
section,wewilldescribethetestsetupandkeyresults.
| | | | | | | | C. RESULTS | | | | | | |
| --- | --- | --- | --- | --- | --- | --- | ---------- | --- | --- | --- | --- | --- | --- |
A. OURMETHODOLOGY The measurement results are shown in Tables 3 and 4. The
Tounderstandthewebenergyconsumptionmethodsindetail,
tablescontaintheamountoftransferreddatainkilobytesand
webuilttwodifferenttestsetups:
CPUenergyconsumptionperprocess(MacOS)orperCPU

1. CPU-basedmeasurementsontheend-userdevice. component(Windows).Thesemeasurementsarerepeatedfor
2. Data transfer-based measurements using an existing non-cachedandbrowser-cachedloadingsofthepages.
   onlinecarboncalculator. Theenergymeasurementsinthetablesaresplitintomea-
   | | | | | | | | surable components | | reported | by | Firefox Profiler. | | It should |
   | ------ | ------------------- | --- | ----------- | -------- | ----- | --- | ------------------ | --- | -------- | --- | ----------------- | --- | --------- |
   | We use | a site, builder.io, | | that can be | rendered | using | two | | | | | | | |
   different front-end frameworks, Qwik and Next.js, with the be noted that the components are completely different in
   | | | | | | | | the two CPU | architectures, | | due | to the intrinsic | differences | |
   | --- | --- | --- | --- | --- | --- | --- | ----------- | -------------- | --- | --- | ---------------- | ----------- | --- |
   samecontent.Wehypothesizethattherenderingframeworks
   havedifferent energyconsumptionandthe resultsvaryalso between architectures and energy measurement capabilities
   | somewhatintheamountofdataproduced. | | | | | | | oftheplatforms. | | | | | | |
   | ---------------------------------- | --------- | ------- | ---------------- | --- | --- | -------- | --------------- | --- | ----------------- | --- | -------- | ----- | ------- |
   | | | | | | | | To illustrate | | the measurements, | | they are | shown | also in |
   | Finally, | we try to | compare | the measurements | | | of these | | | | | | | |
   twomethodologiesandseewhethertheyprovideuniformor Figure 1. The figures show the composition of energy
   consumption,thedifferencebetweenQwikandNext.jsboth
   disparateresults.
   innon-cachedandcachedtests,andalsothedifferentscales
   ofMacM3andWindowsCorei3energyconsumption.
   B. PROFILINGSETUP
   Thefollowingfindingscanbedistilledfromtheresults:
   | We focused | on a single | website, | builder.io,9 | | as | it has | | | | | | | |
   | ---------- | ----------- | -------- | ------------ | --- | --- | ------ | --- | --- | --- | --- | --- | --- | --- |
   been implemented using both Next.js and Qwik JavaScript 1) The results from all five testing rounds are close to
   frameworkswhileservingthesamecontentgivingusagood each other, indicating that both the setup and the
   studytarget.Theframeworkshavebeendescribedearlierin measurements were not affected by external drivers,
   | SubsectionII-D. | | | | | | | suchasbackgroundprocessesinWindowsorbrowser | | | | | | |
   | --------------- | ------- | -------- | --- | --------- | --- | ------ | ------------------------------------------- | --- | --- | --- | --- | --- | --- |
   | We leveraged | Firefox | Profiler | for | measuring | | energy | issues. | | | | | | |
   consumption under MacOS and Windows. We also used 2) Different CPU architectures have a drastic effect on
   two CPU architectures, M3 (Apple, MacOS) and i3 (Intel, energy efficiency. This is partially due to the mea-
   Windows) for our work. To measure power consumption, surementapproachesofFirefoxProfilerdifferbetween
   | we configured | the profiler | to | measure | all threads | with | one | | | | | | | |
   | ------------- | ------------ | --- | ------- | ----------- | ---- | --- | --- | --- | --- | --- | --- | --- | --- |
   millisecondintervalsandexecutedeachtestasfollows: 10AppleM3Prowith6performanceand6efficiencycores,and36GBof
   memory.
   9Whatmakesbuilder.iointerestingisthattherenderingmethodofthesite 1113th Gen Intel Core i3-1315U with 2 performance and 4 efficiency
   | canbechosenusingarenderqueryparameter. | | | | | | | cores,and8GBofmemory. | | | | | | |
   | -------------------------------------- | --- | --- | --- | --- | --- | --- | --------------------- | --- | --- | --- | --- | --- | ------ |
   | VOLUME13,2025 | | | | | | | | | | | | | 139007 |

J.Kalliola,J.Vepsäläinen:ChallengesRelatedtoApproximatingtheEnergyConsumptionofaWebsite
FIGURE1. Thefiguresshowenergyconsumptionmeasurementsforbuilder.iowithMacM3(top)and
WindowsCorei3(bottom).ThebarscontaindifferentenergymeasurementsreportedbyFirefoxProfiler
andthelineshowstheaverageoverfivemeasurementrounds.
CPU architectures. MacOS provides information for causingenergyconsumptionwithinCPU—thedifferencein
each process separately and Windows with Intel pro- JavaScript performance is considerable. It should be noted
cessorsprovidesonlytheinformationofthetotalCPU thatcurrentlythereisnopracticalwaytoseparatetheenergy
powerconsumption,includingalsoallotherprocesses consumedbythesewebpageloadingandrenderingtasks.
running on the system [97]. Specific care was taken As the results provide actual energy consumption in Wh,
duringthemeasurementsthatnootherprogramswere they are more reliable than carbon emission estimates that
runningontheWindowslaptop.However,itshouldbe typically use either a generic coefficient or local energy
notedthatanyWindowsOSandbackgroundprocesses carbon intensity numbers to convert energy to emissions.
runningareincludedinthenumbersunlikeinMacs. Asintensityvariesaroundworld,theemission-basedresults 3) The amount of data transfer varies between operat- varyfromlocationtolocation[99].
| ing | systems, | but | is consistent | between | the frontend | | | | | | | |
| ---------- | -------- | --- | ------------- | ------- | ------------ | ------------- | ----------- | --- | --------- | --- | ----------- | --- |
| libraries. | | | | | | E. REFLECTION | | | | | | |
| | | | | | | The CPU-based | measurement | | was found | to | be a robust | and | 4) Useofbrowsercachinghasa5–7%impactonenergy
consumption on Windows laptops, which is already precise way to measure the browser energy consumption.
| | | | | | | While the | measurements | are | not transferable | | between | CPU |
| ----- | --------- | --- | ----- | -------------- | ----------- | -------------- | ------------ | ------- | ---------------- | --- | ------------ | --- |
| high. | It should | be | noted | that in MacOS, | I/O-related | | | | | | | |
| | | | | | | architectures, | they can | be used | within | an | architecture | to |
CPUenergyconsumptionexternaltoFirefoxprocesses
is excluded from the measurements while Windows compare efficiency. Special care needs to be taken to
| | | | | | | understand | the scope | of measurements, | | as | in certain | cases |
| ------------ | --- | ------- | --- | --------------- | ---------- | ---------- | --------- | ---------------- | --- | --- | ---------- | ----- |
| measurements | | include | it | [97]. The exact | reason for | | | | | | | |
energysavingisnotknownandnotpinpointablewith relevant consumption—such as operating system graphics
| | | | | | | drivers or | I/O in MacOS—is | | excluded | and | sometimes, | |
| --- | --- | --- | --- | --- | --- | ---------- | --------------- | --- | -------- | --- | ---------- | --- |
thecurrenttools;itcouldbeI/OrelatedorduetoSSD
irrelevantconsumptionmaybecountedin.
returningdatafasterthananetworkresultinginafaster
pageloadingthatconsumeslessenergy[97]. There were non-negligible differences in the energy
| | | | | | | efficiency | of the measured | | frameworks | and | also browser | |
| --- | --- | --- | --- | --- | --- | ---------- | --------------- | --- | ---------- | --- | ------------ | --- |
caching,whenmeasurable,hadanimpactontheefficiency.
D. OBSERVATIONS
| Despite | the different | measurements | | between | CPU archi- | | | | | | | |
| --------- | ---------------- | ------------ | ------ | --------- | ---------- | --- | --- | --- | --- | --- | --- | --- |
| tectures, | all measurements | | showed | that Qwik | is 6–10% | | | | | | | |
V. MEASUREMENTSUSINGTRANSFERREDDATA
more energy efficient than Next.js, as seen in Table 5 and Anotherapproachtoestimatingawebsite’senergyconsump-
Figure 1. As measurements also include data downloading, tion is to measure the transferred data and use coefficients
HTML and image rendering, and playing animations—all from the literature to convert that into either energy
| 139008 | | | | | | | | | | | VOLUME13,2025 | |
| ------ | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ------------- | --- |

J.Kalliola,J.Vepsäläinen:ChallengesRelatedtoApproximatingtheEnergyConsumptionofaWebsite
TABLE3. ThetableshowsMacM3measurementresults,includingtheamountoftransferreddata(inkB)andCPUenergyconsumptionperFirefox
process(inmWh).Themeasurementswereexecutedfivetimesforbothnon-cachedandcachedversionsofthepage,andwithtworenderers,Qwikand
Next.js.
TABLE4. ThetableillustratesWindowsCorei3measurementresults,includingtheamountoftransferreddata(inkB)andCPUenergyconsumptionper
CPUcomponent(inmWh).Themeasurementswereexecutedfivetimesforbothnon-cachedandcachedversionsofthepage,andwithtworenderers,
QwikandNext.js.
TABLE5. ThetableshowsacomparisonofQwikandNext.jsperformance.NotetheslightdifferenceinfavorofQwik.
consumptionorcarbonemissions.Inthissection,wemeasure website[81].Thecalculationisexecutedusingversion3of
theemissionsofthebuilder.iosite. theSustainableWebDesignModel[57].Theservicecaches
theresultsofthecalculationsandthusthetestswereexecuted
onlyonceforeachversionofthebuilder.iowebsite.Thetests
A. OVERALLSETUP
wereexecutedasfollows:
Weusedthesamehigh-levelsetupasinSubsectionIV-B.

1. The URL of the site is entered in the ‘‘Your web
   B. MEASUREMENTSETUP page address’’ field on websitecarbon.com and the
   The measurements based on the amount of transferred data ‘‘Calculate’’buttonisclicked.
   were executed using websitecarbon.com online service that 2) If the page results were cached, the service was
   employs the CO2.js library to calculate the emissions of a requestedtorecalculatetheresults.
   VOLUME13,2025 139009

J.Kalliola,J.Vepsäläinen:ChallengesRelatedtoApproximatingtheEnergyConsumptionofaWebsite 3) The resulting page was stored as an image and the tounderstandwhetherthesemeasurementsprovidesimilaror
| carbonemissionestimatewasnoted. | | | | | | disparateresults. | | | | | | |
| ------------------------------- | --- | --- | --- | --- | --- | ----------------- | -------------------- | --- | --------- | ----------- | --------- | --- |
| | | | | | | We employ | the following | | process | to convert | emissions | |
| | | | | | | reported | by websitecarbon.com | | to energy | consumption | | and |
C. RESULTS
The result of the measurement is a web page that states ensurethattheyarecomparable:
Convertemissionstoenergyusingthecarbonintensity
| the estimated | carbon | emissions, | information | | about the | • | | | | | | |
| ------------- | ------ | ---------- | ----------- | --- | --------- | --- | --- | --- | --- | --- | --- | --- |
greenness of the website hosting, and a grade based on the usedbywebsitecarbon.com.
| | | | | | | • Unfurl | the new | and | returning | visitors | formula | of |
| ---------- | -------------- | ----------------- | --- | --- | ----------- | -------- | ------- | --- | --------- | -------- | ------- | --- |
| emissions. | Figure 2 shows | websitecarbon.com | | | screenshots | | | | | | | |
forbuilder.iorenderedusingQwikandNext.jsframeworks. websitecarbon.com.
websitecarbon.comresultforQwikis0.38gofCO perpage • Calculate the client device portion of the energy
2
consumption.
| loadand0.33gofCO | 2 | forNext.js. | | | | | | | | | | |
| ---------------- | --- | ----------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
For an unknown reason, the green hosting lookup for the • CalculatetheCPUenergyconsumptionwithintheclient
deviceenergyconsumption.
Next.jsversionofthesitefailstorecognizethatthesiteruns
ongreenenergy—‘‘thiswebpageusesbogstandardenergy’’.
Thisissuehasbeeninformedtothemaintainersoftheservice A. CONVERTTOSAMEUNITS
andwehaverectifiedthedifferenceinourcalculations.The The first task is to convert the results to employ the same
serviceinforms,asseenontheimages,thattheeffectofgreen units. The default electricity intensity used in websitecar-
hostingis9%,thereforewecanremoveitfromgreenhosted bon.comforcarbonintensityistheglobalaverageelectricity
resultsbydividingthemwith0.91: carbon intensity (442 CO 2 eq/kWh) [56] from the CO 2
intensitydatasetfor‘‘World’’ofEmber’sDataExplorer.12
| 1) Qwik:0.38gCO | | /0.91=0.42gCO | | | | | | | | | | |
| ------------------ | --- | ------------- | --- | --- | --- | ---------- | -------- | --- | ---------- | ---- | ------------- | --- |
| | | 2 | | 2 | | | | | | | | |
| | | | | | | The energy | used can | be | calculated | with | the following | |
| 2) Next.js:0.33gCO | | 2 | | | | | | | | | | |
formula:
energy=emissions/carbonintensity
D. OBSERVATIONS
Whilethemeasurementsmadeonlaptopsindicatedthatthe
Theenergyconsumptionofthemeasurementsisthus:
amountofdownloadeddatawasonaverage4,454kB(Mac)

1. Qwik:845mWh
   and5,192kB(Windows)fortheQwikversionand5,098kB
2. Next.js:668mWh
   | (Mac) and | 5,690 kB (Windows), | | the measurement | | made on | | | | | | | |
   | --------- | ------------------- | --- | --------------- | --- | ------- | --- | --- | --- | --- | --- | --- | --- |
   websitecarbon.comindicatethattheNext.jsversionwouldbe
   lighter. This is probably due to lazy loadingor rendering of B. MANAGENEWANDRETURNINGVISITORS
   | | | | | | | The calculation | formula | used | by websitecarbon.com | | | con- |
   | ----------- | ----------- | -------- | -------- | ---- | -------------- | --------------- | ------- | ---- | -------------------- | --- | --- | ---- |
   | the site in | the Next.js | version: | the site | does | not render the | | | | | | | |
   wholepageatonce,butdefersrenderingandthusloadingof siders new and returning visitors differently, estimating
   | | | | | | | that 75% | of the visitors | are | new | and 25% | are returning. | |
   | --- | --- | --- | --- | --- | --- | -------- | --------------- | --- | --- | ------- | -------------- | --- |
   certainassetsuntiltheuserhasscrolleddownthepage.
   | | | | | | | The returning | visitors’ | weight | is | only 0.02 | of | the new |
   | --- | --- | --- | --- | --- | --- | ------------- | ----------- | ----------- | -------- | --------- | ------------ | ------- |
   | | | | | | | visitors, | which skews | the results | compared | | to CPU-based | |
   E. REFLECTION
   | | | | | | | non-cached | measurements | that | are | 100% | new visitors | in |
   | --- | --- | --- | --- | --- | --- | ---------- | ------------ | ---- | --- | ---- | ------------ | --- |
   Thefollowingfindingscanbedistilledfromtheliteratureand
   websitecarbon.com.Theenergyusageiscalculatedusingthe
   measurementresults:
   followingformula[56]:
   Thedatatransfer-basedservicesprovideeasytouse,yet
   | • | | | | | | | =[DataTransfer×0.81kWh/GB×0.75] | | | | | |
   | --- | --- | --- | --- | --- | --- | --- | ------------------------------- | --- | --- | --- | --- | --- |
   E
   disputed[51],[89],[90],[91],[92]waytoestimatethe +[DataTransfer×0.81kWh/GB×0.25×0.02]
   emissionsofawebpagerequestandrendering.
   • Thetestfailedtoacknowledgethelazyrenderingofthe
   Next.js version of the site, most probably due to not =[DataTransfer×0.81kwh/GB×0.755]
   E
   executingJavaScriptduringthemeasurement.
   E
   | • The | green hosting | lookup | did not | work | for the Next.js | DataTransfer= | | | | | | |
   | ----- | ------------- | ------ | ------- | ---- | --------------- | ------------- | --- | --- | --- | --- | --- | --- |
   0.81kWh/GB×0.755
   | version | measurements | properly, | raising | | concerns about | | | | | | | |
   | ------- | ------------ | --------- | ------- | --- | -------------- | --- | --- | --- | --- | --- | --- | --- |
   theimplementationqualityofthemeasuringsystem. Theamountstransferredareasfollows:
   • There is very little information available on how the 1) Qwik:1,381kB
   systemresultsinthemeasurement,astheamountofdata 2) Next.js:1,092kB
   ordownloadedfilesisnotdisclosed. It should be noted that these numbers are approximately
   | | | | | | | 4-5 smaller | compared | to the | data | transfer | measured | with |
   | --- | --- | --- | --- | --- | --- | ----------- | -------- | ------ | ---- | -------- | -------- | ---- |
   VI. COMPARINGMEASUREMENTS FirefoxPowerProfilerasseeninthelistbelow:
   | The results | of the two | measurements | | are | not directly | | | | | | | |
   | ----------- | ---------- | ------------ | --- | --- | ------------ | --- | --- | --- | --- | --- | --- | --- |
3. Qwik:4,454kB(Mac),5,192kB(Windows)
   comparable,asthemeasurementsyieldvalueswithdifferent 2) Next.js:5,098kB(Mac),5,690kB(Windows)
   unitsandnon-compatiblescopesthatareincludedinthemea-
   12ember-energy.org/data/electricity-data-explorer.
   surements.However,wecanmakearudimentarycomparison
   | 139010 | | | | | | | | | | | VOLUME13,2025 | |
   | ------ | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ------------- | --- |

J.Kalliola,J.Vepsäläinen:ChallengesRelatedtoApproximatingtheEnergyConsumptionofaWebsite
FIGURE2. Thefigureshowscarbonemissionestimationresultsforbuilder.iorenderedwithQwik(left)andbuilder.io?render=next
renderedwithNext.js(right)fromwebsitecarbon.com.TheleftvariantwithQwikshowedestimated0.38gofCO2andreceivedthe
gradeCwhilethevariantwithNext.jsshowedestimated0.33gofCO2andreceivedgradeB.Further,websitecarbon.comconcluded
erroneouslythatQwikrenderedversionwasrunningonsustainableenergy,whileNext.jsrenderedversionwasnot.
Theconsumedenergycanbecalculatedbymultiplyingthe theFirefoxPowerProfilerinourWindowsmeasurement.The
datatransferfiguresby0.81kWh/GB: measurementsshowedthattheCPUpowerconsumptionwas

1. Qwik:1,119mWh between40%and63%ofthetotalpowerdrawunderload.
   ThesemeasurementsareallforIntel-basedcomputersand
2. Next.js:884mWh
   | | | | | | | | they cannot | be translated | | directly | on Apple | M3 | hardware, | |
   | --- | --- | --- | --- | --- | --- | --- | ----------- | ------------- | ---- | -------------- | -------- | ------ | --------- | --- |
   | | | | | | | | as while | the CPU | with | its integrated | | memory | architec- | |
   C. CALCULATETHECLIENTDEVICEPORTION
   AccordingtoAdams[56],theconsumerdeviceuseconsists ture[103]ismoreenergyefficient,therestofthecomputer,
   of 52% of the energy consumption in websitecarbon.com suchasdisplay,I/Odevices,andstorage,aresimilarbetween
   | | | | | | | | hardware | architectures. | Furthermore, | | the | article | by Mahesri | |
   | --- | --- | --- | --- | --- | --- | --- | -------- | -------------- | ------------ | --- | --- | ------- | ---------- | --- |
   measurements,andthelaptopenergyconsumptionsare:
   | | | | | | | | and Vardhan | [101] | indicates | that | the distribution | | depends | |
   | --- | --- | --- | --- | --- | --- | --- | ----------- | ----- | --------- | ---- | ---------------- | --- | ------- | --- |
3. Qwik:582mWh
   | | | | | | | | on the use | case | and there | is no | recent | study | on the | power |
   | --- | --- | --- | --- | --- | --- | --- | ---------- | ---- | --------- | ----- | ------ | ----- | ------ | ----- |
4. Next.js:460mWh
   distributionofwebbrowsing.
   D. ESTIMATECPUPORTIONOFENERGYCONSUMPTION
   E. REFLECTION
   | Comparing | these numbers | that | contain | | the whole | laptop | | | | | | | | |
   | -------------- | ------------- | ---------- | ------- | -------- | ----------- | ------- | -------------- | -------------- | ---------- | --------------- | ------- | ------------- | ------------ | --- |
   | | | | | | | | The comparison | | between | the measurement | | methodologies | | |
   | electricity | consumption | with | the CPU | power | consumption | | | | | | | | | |
   | | | | | | | | does not | yield directly | comparable | | results | due | to different | |
   | of the Windows | laptop | non-cached | | averages | of | 179 mWh | | | | | | | | |
   approachestoenergyconsumption,unknowndistributionof
   | (Qwik) | and 190 mWh | (Next.js) | | leaves | 403 | mWh and | | | | | | | | |
   | ------ | ----------- | --------- | --- | ------ | --- | ------- | --- | --- | --- | --- | --- | --- | --- | --- |
   energybetweenlaptopcomponents,andtheopaquenatureof
   | 270 mWh, | respectively, | for | the | rest | of the | laptop to | | | | | | | | |
   | -------- | ------------- | --- | --- | ---- | ------ | --------- | --- | --- | --- | --- | --- | --- | --- | --- |
   thetransferreddata-basedmethodology.
   consume.13
   TheAppleMCPUarchitectureisstrikinglymoreefficient
   On Mac, the same numbers are only 4.645 mWh (Qwik) compared to the Intel i3 architecture. This is partially due
   and5.104mWh(Next.js),leaving577mWhand455mWh,
   | | | | | | | | to the different | | methodologies | | employed | to measure | | CPU |
   | --- | --- | --- | --- | --- | --- | --- | ---------------- | --- | ------------- | --- | -------- | ---------- | --- | --- |
   respectively,whichisplentyofroomforthedisplay,memory,
   | | | | | | | | energy consumption | | but | does not | explain | the | difference | as |
   | --- | --- | --- | --- | --- | --- | --- | ------------------ | --- | --- | -------- | ------- | --- | ---------- | --- |
   coolingfan,andperipherals.
   awhole.
   Unfortunately,thereislittlerecentliteratureonthedistri-
   | | | | | | | | As discussed | | in Subsection | | III-D, | the weight | | of the |
   | --- | --- | --- | --- | --- | --- | --- | ------------ | --- | ------------- | --- | ------ | ---------- | --- | ------ |
   bution of energy consumption between various components end-userdeviceinthedatatransfer-basedmodelis52%[56],
   | of a laptop. | Studies | from 1996 | [100] | and | 2005 | [101] are | | | | | | | | |
   | ------------ | ------- | --------- | ----- | --- | ---- | --------- | --- | --- | --- | --- | --- | --- | --- | --- |
   [83].However,thereisawidevarianceinenergyconsump-
   clearlyoutdated.
   tionbetweendifferentCPUarchitecturesthatshouldbetaken
   | In a study | by Prieto | et al. | [102], | the CPU | measurements | | | | | | | | | |
   | ---------- | --------- | ------ | ------ | ------- | ------------ | --- | --- | --- | --- | --- | --- | --- | --- | --- |
   intoconsiderationindatatransfer-basedmeasurements.
   ofrecent(2022)computersarecomparedtothetotalpower
   | draw measured | with | the OpenZMeter | | tool. | Linpack, | which | | | | | | | | |
   | ------------- | ---- | -------------- | --- | ----- | -------- | ----- | --- | --- | --- | --- | --- | --- | --- | --- |
   VII. DISCUSSION
   | is a computer | program | that solves | | a dense | system | of linear | | | | | | | | |
   | ------------- | ------- | ----------- | --- | ------- | ------ | --------- | -------- | ---------- | ----------- | --- | ------ | --- | ------ | --- |
   | | | | | | | | Although | the global | consumption | | of the | ICT | sector | and |
   equations,generatesaloadforthemeasurements.TheCPU
   | | | | | | | | the web | is fairly | well understood, | | it is | not so | clear | what |
   | ---------- | ------------ | ---- | --- | ---- | ---- | --------- | ---------------- | --------- | ---------------- | ------ | ------------- | ------- | ----- | ------ |
   | power draw | was measured | with | the | same | RAPL | system as | | | | | | | | |
   | | | | | | | | is the situation | at | a low | level. | Interestingly | enough, | | in our |
   measurements,wegainedcontradictoryresultsthatpointout
   13Additionally,itwouldbepossibletomeasuretheconsumptionofthe
   wholelaptopusinganexternalmeasurementdeviceconnectedtotheplug. how difficult the task is. Through the effort of measuring a
   | VOLUME13,2025 | | | | | | | | | | | | | | 139011 |
   | ------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ------ |

J.Kalliola,J.Vepsäläinen:ChallengesRelatedtoApproximatingtheEnergyConsumptionofaWebsite
singlewebsite,wewereabletomakeaseriesofobservations The results we gathered conflict, as Qwik powered
ranging from hardware, techniques, and the current state of version of the site was found more performant in both
theresearchspace. MacOS and Windows measurements, while according to
websitecarbon.comitemittedmoreemissions.
A. CPUARCHITECTURESCANHAVEMASSIVE
Shouldthecalculatorsdiscloseintermediarysteps,suchas
DIFFERENCESINCONSUMPTION
| | | | | | | | | listing the | assets | downloaded | with | their | sizes, | it would | help |
| --- | --- | --- | --- | --- | --- | --- | --- | ----------- | ------ | ---------- | ---- | ----- | ------ | -------- | ---- |
Different CPU architectures have a drastic effect on energy to understand the scope of the measurement and potential
| efficiency. | MacOS | results | were | less | than | one-thirtieth | of | | | | | | | | |
| ------------ | ----------- | --------- | ----- | -------- | ---- | ------------- | ----------- | ---------- | ---------- | --------- | ------------- | ------ | ----------- | ------- | ------- |
| | | | | | | | | omissions. | We decided | | opt to manual | | measurement | | process |
| Windows | results. | It should | | be noted | that | the laptops | are | | | | | | | | |
| | | | | | | | | in Section | IV | to ensure | that | we had | full | control | of the |
| not directly | comparable; | | while | the | Mac | is a | top-of-the- | | | | | | | | |
measurements.
| line laptop, | the | Windows | laptop | can | be | considered | as a | | | | | | | | |
| ------------ | --- | ------- | ------ | --- | --- | ---------- | ---- | ---- | -------- | ----- | ----------- | --- | ---------------- | --- | --- |
| | | | | | | | | As a | note, we | tried | to automate | | the measurements | | in |
middle-tiermodel.ThedevelopersofFirefoxPowerProfiler Section IV using Sitespeed.io that is an open source tool
wereexpecting10-20folddifferencesbetweentheprocessor
| | | | | | | | | that helps | to | analyze | and optimize | | website | speed | and |
| --- | --- | --- | --- | --- | --- | --- | --- | ---------- | --- | ------- | ------------ | --- | ------- | ----- | --- |
architectures[97].
performance,basedonperformancebestpractices[104].The
WhiletheCPUpowerconsumptionhashugedifferences,
| | | | | | | | | results were | flawed | due | to a bug | that | made the | Sitespeed.io | |
| --------- | -------- | ----------- | --- | ----- | ------- | --- | -------- | ------------ | -------- | --- | ------------------ | ---- | -------- | ------------ | ------ |
| we cannot | directly | extrapolate | | these | numbers | to | computer | | | | | | | | |
| | | | | | | | | system | use only | the | first measurements | | provided | | by the |
power consumption. There are only a few articles [100], Firefox Profiler, and also the units were wrong [105]. Such
[101],[102]aboutthepowerdistributionbetweencomputer
| | | | | | | | | issues highlight | | how | early stages | we | are at | in measuring | |
| ----------- | --- | ----- | ----------- | --- | ---- | ---------------- | --- | ---------------- | --- | --- | ------------ | --- | ------ | ------------ | --- |
| components, | and | [101] | exemplifies | | that | the distribution | | | | | | | | | |
websiteperformance.Tomeasurenumerouswebsitestogain
dependsontheusecase.
| | | | | | | | | a better | understanding | | of energy | consumption | | as a | whole, |
| --- | --- | --- | --- | --- | --- | --- | --- | -------- | ------------- | --- | --------- | ----------- | --- | ---- | ------ |
anautomatedsolutionisrequired.
B. THEIMPACTOFBROWSERCACHESEEMSMODEST
TheresultsinTables3and4containmeasurementswithout
D. TOOLSUSECO2.JSVERSION3OR4
browsercache—inotherwords,thecachewasclearedbefore
AsstatedinSubsectionIII-D,thecurrentversionofCO2.js
| the page | was loaded—and | | with | a | page loaded | | once into | | | | | | | | |
| -------- | -------------- | --- | ---- | --- | ----------- | --- | --------- | --- | --- | --- | --- | --- | --- | --- | --- |
is4,whilewebsitecarbon.comisstillusingversion3.Version
browsercacheandthenreloaded.
| | | | | | | | | 4 has a | more complex | | calculation | formula | | that uses | more |
| ------- | ------ | ----------- | --- | --- | ------ | ------ | ------ | ------- | ------------ | --- | ----------- | ------- | --- | --------- | ---- |
| The CPU | energy | consumption | | had | little | effect | in the | | | | | | | | |
fine-grainedcoefficientsandusesavaluebetween0and1for
| MacOS | laptop | and 5-7% | efficiency | | gain | in the | Windows | | | | | | | | |
| ----- | ------ | -------- | ---------- | --- | ---- | ------ | ------- | --- | --- | --- | --- | --- | --- | --- | --- |
thegreenhostingimpact.
laptop.Thisispartiallyduetodifferencesinmeasurements,
| | | | | | | | | Should | the | websitecarbon.com | | upgrade | | to version | 4, |
| --- | --- | --- | --- | --- | --- | --- | --- | ------ | --- | ----------------- | --- | ------- | --- | ---------- | --- |
asinMacOSCPUarchitecture,themeasurementisbasedon
| | | | | | | | | the measurements | | should | be | re-executed. | | As stated | in |
| --- | --- | --- | --- | --- | --- | --- | --- | ---------------- | --- | ------ | --- | ------------ | --- | --------- | --- |
processes,andallI/OprocessesexecutedoutsideofFirefox,
SubsectionVII-C,theopaquenatureofthetoolmakesithard
| i.e. on the | operating | | system | level, | are excluded | | from the | | | | | | | | |
| ----------- | --------- | --- | ------ | ------ | ------------ | --- | -------- | --------- | -------- | ----------- | --- | ------- | ---- | ------- | ------- |
| | | | | | | | | to switch | only the | calculation | | formula | from | version | 3 to 4, |
results.
aswedonothavetheexactamountoftransferreddata.
Theefficiencygainofcachingisapproximatelythesame
| as the difference | | between | frontend | | frameworks | | (6-10%). | | | | | | | | |
| ----------------- | --- | ------- | -------- | --- | ---------- | --- | -------- | --- | --- | --- | --- | --- | --- | --- | --- |
E. LACKOFSCIENTIFICARTICLESANDHORIZON
Thus,buildingthewebsiteusingamoreefficientframework
| | | | | | | | | While there | is | plenty | of discussion | | around | the | energy |
| --- | --- | --- | --- | --- | --- | --- | --- | ----------- | --- | ------ | ------------- | --- | ------ | --- | ------ |
andusingpropercachingheaderscanresultinsavingsof13% consumption of websites, there are few scientific articles
| in CPU | energy | consumption | | in the | Windows | laptop. | That | | | | | | | | |
| ------ | ------ | ----------- | --- | ------ | ------- | ------- | ---- | --- | --- | --- | --- | --- | --- | --- | --- |
aboutmeasuringorestimatingtheconsumptionoremissions.
savingcanbeconsideredalreadysubstantial.
Thevariousonlinetoolshavenotbeenreviewedoranalyzed
| It should | be | highlighted | | that the | exact | reason | for the | | | | | | | | |
| --------- | --- | ----------- | --- | -------- | ----- | ------ | ------- | --- | --- | --- | --- | --- | --- | --- | --- |
inpeer-reviewedarticles,andwehadtoresorttoblogposts
| efficiency | gain | is unclear | and | cannot | be | resolved | with | | | | | | | | |
| ---------- | ---- | ---------- | --- | ------ | --- | -------- | ---- | --- | --- | --- | --- | --- | --- | --- | --- |
asreferencesrelatedtosuchtools.
| current tools. | The | gain | could | be due | to reduced | I/O | or SSL | | | | | | | | |
| -------------- | --- | ---- | ----- | ------ | ---------- | --- | ------ | ------ | ---------- | --------- | --- | ----- | ------- | ------- | ----- |
| | | | | | | | | One of | the issues | comparing | | these | numbers | is that | there |
decryption,orSSDdrivereturningdatafasterthannetwork—
| | | | | | | | | is no dataset | | of website | energy | consumption | | and | thus |
| --- | --- | --- | --- | --- | --- | --- | --- | ------------- | --- | ---------- | ------ | ----------- | --- | --- | ---- |
whichresultsinafasterpageloading,whichconsumesless
| | | | | | | | | it is hard | to say | whether | a | site has | an excellent, | | good, |
| --- | --- | --- | --- | --- | --- | --- | --- | ---------- | ------ | ------- | --- | -------- | ------------- | --- | ----- |
energy[97]
| | | | | | | | | or poor | energy | consumption | profile. | | Google | has collected | |
| --- | --- | --- | --- | --- | --- | --- | --- | ----------- | ------ | ----------- | -------- | --------- | ------ | ------------- | ----- |
| | | | | | | | | performance | scores | as | part of | their Web | Vitals | [106] | using |
C. MANYMEASUREMENTTOOLSARENOTTRANSPARENT
| | | | | | | | | three measurements | | (known | as | Core | Web Vitals | or | CWV): |
| --- | --- | --- | --- | --- | --- | --- | --- | ------------------ | --- | ------ | --- | ---- | ---------- | --- | ----- |
INTHEIRCALCULATIONS
While the CO2.js library is well-documented [81] and uses the largest contentful paint (LCP), the first input delay
(FID),andthecumulativelayoutshift(CLS)[107].Asstated
coefficientsfromscientificresearch[82],theexactuseofthe
library within various carbon calculators is not disclosed as in [53], such performance scores act as a proxy of energy
consumption—buttheydonotprovidedirectmeasurements
| part of the | calculator | | documentation. | | It is | not clear | which | | | | | | | | |
| ----------- | ---------- | --- | -------------- | --- | ----- | --------- | ----- | --- | --- | --- | --- | --- | --- | --- | --- |
ofenergyconsumption.
| assets of | the web | page | are downloaded | | as | part of | the data | | | | | | | | |
| --------- | -------- | ---- | -------------- | -------- | -------- | ------- | ----------- | --- | --- | --- | --- | --- | --- | --- | --- |
| transfer | estimate | and | which | are not. | Lecorney | | et al. [94] | | | | | | | | |
found several problems and our measurements had similar F. PRACTICALIMPLICATIONSANDTOOLLIMITATIONS
problems, but due to the opaqueness of the tool, we cannot The results strongly indicate that the data transfer-based
pinpointtheexactomissions. measurementmethodologiesarenotreliableenoughtobuild
| 139012 | | | | | | | | | | | | | | VOLUME13,2025 | |
| ------ | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ------------- | --- |

J.Kalliola,J.Vepsäläinen:ChallengesRelatedtoApproximatingtheEnergyConsumptionofaWebsite
on the energy performance of a web page. As shown in I. THREATSTOVALIDITY
| Table 1, | the measurement | | tools | available | are | based | on the | | | | | | |
| -------- | --------------- | --- | ----- | --------- | --- | ----- | ------ | ------------------ | --- | -------------------- | --- | --- | --------- |
| | | | | | | | | The implementation | | of websitecarbon.com | | is | not docu- |
datatransfermethodology.Thisposesaproblemforwebsite mented outside the CO2.js library and it does not provide
developers who want to reduce the energy consumption of intermediary calculations. Thus, we had to calculate the
theirproducts,asthecurrenttoolsareunpredictable. amountoftransferreddatabasedoncarbonemissionsusing
Instead, CPU-based measurements provide more precise the formula shown in [56]. The exact use of the formula
| results within | a | CPU architecture, | | but | they | are not | easily | | | | | | |
| -------------- | --- | ----------------- | --- | --- | ---- | ------- | ------ | --- | --- | --- | --- | --- | --- |
insidewebsitecarbon.comisnotdisclosed,andwecouldhave
generalizable to yield comparable results between architec- miscalculatedtheresults.
tures. The toolchain is also less polished compared to the The CPU-based measurements were done manually to
datatransfermethods.Furthermore,nodataareavailableon have full control of the process. The manual nature opens
theperformanceofwebsitesingeneral,makingitdifficultto avenuesforhumanerrorsandmakestimingharder.Werec-
understandwhetherasiteconsumeslessormoreenergythan
| | | | | | | | | tified these | by using | a scrolling | plugin, | using | the same |
| --- | --- | --- | --- | --- | --- | --- | --- | ------------ | -------- | ----------- | ------- | ----- | -------- |
sitesonaverage. choreography and timings with all measurement clicks, and
Finally, neither one of the measurement approaches startingmeasurementswithonlyasingletabopeninFirefox
provides insight into the energy consumption of server-side toreducethepossibilityofin-browsernoise.Allnon-required
| HTMLgenerationandassetdownloading. | | | | | | | | pluginswereturnedoff. | | | | | |
| ---------------------------------- | --- | --- | --- | --- | --- | --- | --- | --------------------- | --- | --- | --- | --- | --- |
IntheWindowsplatform,CPUmeasurementsencompass
G. COMPARISONTOOTHERMETHODOLOGIES all software operating on the computer. To reduce external
In our research, we have focused on software-based energy noise,themeasurementswereconductedusingFirefoxasthe
| measurement | solutions. | | There | are | also hardware-based | | | | | | | | |
| ----------- | ---------- | --- | ----- | --- | ------------------- | --- | --- | --- | --- | --- | --- | --- | --- |
solesoftwareapplication.
solutions, such as using a wattmeter to measure the amount Due to differences in window frames in MacOS and
of energy consumed by the laptop, a dedicated device such Windows,thebrowserviewportisnotthesamesizeonboth
as OpenZMeter [108] or Vampire [109], or using hardware platforms.Weconsiderthisanegligibleissue.
instrumentationavailableoncertainlaptops[110]. As there is a possibility for us not understanding the
Hardwaresolutionstypicallyprovidemorepreciseresults
| | | | | | | | | Firefox | Power Profiler | readings | the | right way, | we had |
| --- | --- | --- | --- | --- | --- | --- | --- | ------- | -------------- | -------- | --- | ---------- | ------ |
[109], as they do not cause measurement overhead or use extensivediscussionswithFirefoxPowerProfilerdevelopers,
estimations. However, they require investment in dedicated whoalsodouble-checkedourmeasurementresults.
hardware and they typically measure the overall energy Allduecareanddoublecheckshavebeenmadetorecord
consumptionofadevice.Instrumentationisanexceptionto thenumbers fromFirefox PowerProfiler toTables3 and4,
thisbutisavailableonlyonafewlaptops[110].Someofthe
butthereisapossibilityofwritingdownthenumberwrong.
hardware tools provide methods to gather the measurement However,thereisonlyalittledeviationinthenumbersexcept
results for further analysis [108] while others provide only forthecacheddatatransfers.
currentinformation[110].
Whiletheprecisionandabilitytomeasurethewholedevice
| | | | | | | | | VIII. CONCLUSION | | | | | |
| ------------------ | --- | --- | ----------- | --- | ------- | -------- | --- | ---------------- | --- | --- | --- | --- | --- |
| energy consumption | | are | beneficial, | we | decided | to focus | on | | | | | | |
Basedonourfindings,measuringtheenergyconsumptionof
| software | tools to | a) allow | as | wide use | as possible | | and b) | | | | | | |
| -------- | -------- | -------- | --- | -------- | ----------- | --- | ------ | --- | --- | --- | --- | --- | --- |
awebsiteisnotaneasyproblemandoccasionallyresultsmay
| to drill down | to | the energy | consumption | | that | is affected | by | | | | | | |
| ------------- | --- | ---------- | ----------- | --- | ---- | ----------- | --- | --- | --- | --- | --- | --- | --- |
becontradictory.Tounderstandthetopicindetail,wesought
thewebpage.EspeciallyinAppleMCPUs,theCPUenergy
toanswertworesearchquestions:RQ1:Whatarethefactors
consumptionwemeasuredissosmallthatitmightnotshow
contributingtotheenergyusageoftheweb?andRQ2:How
whenmeasuringthewholelaptopconsumption.
isitpossibletomeasuretheenergyconsumptionoftheweb
atthemomentusingavailabletools?.
H. LIMITATIONS
ForRQ1,wewereabletodiscoverseveralfactorsranging
Themainlimitationofourmeasurementswasthatwefocused
fromcachingtotechnicalchoice.TheshortanswerforRQ2
| on the performance | | of | a single | website, | builder.io. | | This | | | | | | |
| ------------------ | -------- | -------------- | -------- | -------- | ----------- | ------------ | ------ | ---------- | ---------- | ---------- | ---------- | ------------ | ---------- |
| | | | | | | | | is that it | seems that | there is | still work | to be done | especially |
| specific | site was | selected, | because | | a) it is | a commercial | | | | | | | |
| | | | | | | | | to make | it easier | to measure | energy | consumption. | Simul- |
| site instead | of a | site developed | | in the | project | and b) | it has | | | | | | |
tanouslyservicesmeasuringenergyconsumptionshouldaim
| been implemented | | using | two | frontend | frameworks. | | It must | | | | | | |
| ---------------- | --- | ----- | --- | -------- | ----------- | --- | ------- | ---------------- | --- | ------------- | -------- | ---------- | -------- |
| | | | | | | | | for transparency | in | their results | to allow | evaluation | of their |
beacknowledgedthatthemeasurementsandthusresultsare
reliability.
| using limited | source | material | | and not | generalizable | | sites at | | | | | | |
| ------------- | ------ | -------- | --- | ------- | ------------- | --- | -------- | --- | --- | --- | --- | --- | --- |
large.
Anotherlimitationwasthatourmeasurementsfocusedon A. RQ1–WHATARETHEFACTORSCONTRIBUTINGTOTHE
the Qwik and Next.js frameworks which represent a small ENERGYUSAGEOFTHEWEB?
subset of available options, even if Next.js is widely used ToaddressRQ1,weperformedenergymeasurementsagainst
outofthetwo[111].Therefore,itisdifficulttosayhowthe builder.io, a site implemented in both Qwik and Next.js
frameworksinquestioncomparetootheravailableoptionsin JavaScript frameworks. We found out that the energy
general. consumption difference between the frameworks versions
| VOLUME13,2025 | | | | | | | | | | | | | 139013 |
| ------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ------ |

J.Kalliola,J.Vepsäläinen:ChallengesRelatedtoApproximatingtheEnergyConsumptionofaWebsite
was 6–10%, in favor of Qwik, on both tested platforms theseissues,wecannotrecommendusingthetooltomeasure
(MacOS, Windows) and without caching. As the energy is websiteemissionsorenergyconsumption.
consumedbyotherbrowserfunctionalities,suchasrendering Both measurements measure only a single page of a
HTML and images and playing videos, we consider the website for initial load, and as websites may have several
differencehigh.Itshouldbenotedthatboththeseframeworks thousands of pages of varying complexity in content and
are already high-performing ones. The difference between functionality,calculatingasinglenumberasanestimationof
themandalessperformantframeworkwouldmostlikelybe energyconsumptionorcarbonemissionsisextremelytedious
evenhigher. using these methodologies. It is important to note that a
The energy saving of browser caching was found to be websitecanuseaconsiderableamountofenergyduringusage
approximately5–7%inWindowsandnegligibleinMacOS, [97]andourmeasurementsdidn’tcapturethisdynamic.
due to MacOS power profiling not considering external Based on our analysis, the CPU-based measurements
processesandthusrenderinganyoperatingsystemprocesses providepreciseandrobustenergyconsumptioninformation,
out of the results. Again, the difference is substantial, and while the data transfer-based estimations are not reliable.
propercachingcanbeconsideredanexcellentandeasyway It should be noted that both measurement methodologies
to reduce energy consumption in the end-user device. The measure the consumption only in a single location of the
effect on data transfer is even more drastic, dropping on web page request and rendering process. Further research
averagefrom4,454kBto134kB(QwikonMac),5,098kB is needed to capture the precise energy consumption of the
to 251 kB (Next on Mac), 5,192 kB to 200 kB (Qwik on wholeprocess.
Windows)and5,690kBto286kB(NextonWindows).The
bandwidthsavedvariedfrom95%to97%.
| | | | | | | | C. CONCLUDINGREMARKS | | | | | | |
| --- | --- | --- | --- | --- | --- | --- | -------------------- | --- | --- | --- | --- | --- | --- |
Thedatatransfer-basedmeasurementdidnotprovideany
| | | | | | | | The ICT | industry | has | been observed | to | consume | energy |
| --------- | ----- | ------------- | --------- | ----------- | --- | ------- | ---------------- | -------- | ---- | ------------------ | --- | ------- | ---------- |
| findings. | Quite | the contrary, | it showed | conflicting | | numbers | | | | | | | |
| | | | | | | | at an increasing | | rate | [7]. As previously | | stated, | the web is |
to the CPU-based measurements. As we had full control of considered to be the most significant application platform
theCPU-basedmeasurements,weconsiderthemtobecloser
| | | | | | | | [2] and | one of | the largest | segments | of | consuming | digital |
| ----------- | ------------ | --- | ------------- | --------- | --- | ------ | ------- | ------ | ----------- | -------- | --- | --------- | ------- |
| to reality. | In CPU-based | | measurements, | selecting | | a more | | | | | | | |
content[41].Itisimperativetocomprehendandmitigateits
optimizedrenderinglibraryandusingcachesproperly,ledto
| | | | | | | | energy consumption. | | However, | | the prevailing | trends | in web |
| --- | --- | --- | --- | --- | --- | --- | ------------------- | --- | -------- | --- | -------------- | ------ | ------ |
5–10%energysavingsinourtestcases.
developmentarecausingthesitestoexpandinsize[34],[35],
| | | | | | | | [36], which | affects | also | the energy | consumption. | | There is a |
| --- | --- | --- | --- | --- | --- | --- | ----------- | ------- | -------- | ----------- | ------------ | ----------- | ---------- |
| | | | | | | | clear need | for | a simple | methodology | for | calculating | energy |
B. RQ2–HOWISITPOSSIBLETOMEASURETHEENERGY
consumptiontoreducethenegativeimpactofthewebonthe
CONSUMPTIONOFTHEWEBATTHEMOMENTUSING
planet.
AVAILABLETOOLS?
Weapproachedmeasuringwebenergyconsumptionusing
For RQ2, we measured energy consumption or estimated moderntoolsavailabletowebdevelopers.Wefoundthatthe
emissionsoftwoimplementationsofthesamesitewithtwo
commonlyuseddatatransfer-basedmethodsdonotprovide
differentmethodologies,CPU-basedanddatatransfer-based,
| | | | | | | | reliable results | | [88], [89], | [90], | as they do | not | consider all |
| --- | --- | --- | --- | --- | --- | --- | ---------------- | --- | ----------- | ----- | ---------- | --- | ------------ |
and compared the results first within the methodology and webpageassets[94],providedisparateresults[89],[90],and
thenbetweenmethodologies.
theemployedcalculationmethodologiesarenottransparent.
Theend-userdevicemeasurementsusingFirefoxProfiler WestronglyadvocateusingCPUenergyconsumption-based
| provided | consistent | energy | consumption | numbers | | on both | | | | | | | |
| -------- | ---------- | ------ | ----------- | ------- | --- | ------- | --- | --- | --- | --- | --- | --- | --- |
methodsinstead.Finally,itisevidentthatfurtherresearchis
| architectures. | While | the | results | are not directly | comparable | | | | | | | | |
| -------------- | ----- | --- | ------- | ---------------- | ---------- | --- | --- | --- | --- | --- | --- | --- | --- |
requiredontheareaandseveralfuturestudiesarenecessaryto
between architectures and they cannot be extrapolated to constructauniversalandprecisemeasurementmethodology.
| cover the | whole | device | due to | lack of researched | | data, | | | | | | | |
| ------------ | ----------- | ------ | --------- | ------------------ | --- | --------- | ------------------------------ | --- | --- | --- | --- | --- | --- |
| they provide | differences | | in energy | consumption | of | different | | | | | | | |
| | | | | | | | D. POTENTIALRESEARCHDIRECTIONS | | | | | | |
frontendframeworks.
Asseenfromtheresultsoftwodifferentmeasurements,there
FirefoxProfilerwasbuiltprimarilytoallowthemeasure-
| | | | | | | | is a clear | and urgent | need | for commensurate | | measurements | |
| --- | --- | --- | --- | --- | --- | --- | ---------- | ---------- | ---- | ---------------- | --- | ------------ | --- |
mentoftheenergyconsumptionofFirefoxitselfbutitturned
thatwouldtakeintoaccountenergyconsumptioninthedata
| outto bea | usefultool | | forweb developersaswell | | | [95].Our | | | | | | | |
| --------- | ---------- | --- | ----------------------- | --- | --- | -------- | --- | --- | --- | --- | --- | --- | --- |
center,network,andconsumerdeviceseparately.Itwouldbe
| research | showed | that | it can be | used as a | website | energy | | | | | | | |
| -------- | ------ | ---- | --------- | --------- | ------- | ------ | ---------- | ------ | ----- | ------ | ------------------ | --- | ---------- |
| | | | | | | | beneficial | to use | local | energy | carbon intensities | | instead of |
consumptionmeasurementtool,butitisimportanttokeepin
globalones.
mindthatFirefoxProfilerwasnotdesignedforsuchinterms
Eachofthesemeasurementshasitsownsetofissuesand
| of user | interface. | On | the contrary, | the data | transfer-based | | | | | | | | |
| ------- | ---------- | --- | ------------- | -------- | -------------- | --- | --- | --- | --- | --- | --- | --- | --- |
providesfutureresearchdirections:
| approach | was found | to | be problematic | on several | | accounts: | | | | | | | |
| -------- | --------- | --- | -------------- | ---------- | --- | --------- | --- | --- | --- | --- | --- | --- | --- |
failing to calculate the data transfers properly, failing to 1) There is a research gap in understanding the power
recognize green hosting and not being able to turn this distribution between laptop components during web
recognition off, and using global average energy carbon browsing. Without that information, it is practically
intensity number that is more than two years old. Due to impossible to estimate the energy consumption of the
| 139014 | | | | | | | | | | | | VOLUME13,2025 | |
| ------ | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ------------- | --- |

J.Kalliola,J.Vepsäläinen:ChallengesRelatedtoApproximatingtheEnergyConsumptionofaWebsite
laptopfromtheCPUpowermeasurements.Research- [4] T. Ojala, M. Mettälä, M. Heinonen, and P. Oksanen, ‘‘The ict
ingpowerdistributionwouldallowextrapolatingCPU sector, climate and the environment: Interim report of the working
group preparing a climate and environmental strategy for the ICT
measurementstofulllaptopestimates.
sector in Finland,’’ Publications Ministry Transport Communications, 2) As the network energy consumption is mostly static MinistryTransportCommunications,Finland,2020.[Online].Available:
notwithstanding the amount of data transferred [47], https://julkaisut.valtioneuvosto.fi/handle/10024/162473
[5] IEA. Electricity Consumption–Electricity Information: Overview–
thedatatransfer-basedmeasurementsshouldtakethis
Analysis.Accessed:Sep.12,2024.[Online].Available:https://www.iea.
into account. This would require research work on org/reports/electricity-information-overview/electricity-consumption
buildingbetterestimationmodels. [6] How is EU Electricity Produced and Sold. Accessed: 3) There is no proper data available on the energy Feb. 21, 2025. [Online]. Available: https://www.consilium.
europa.eu/en/infographics/how-is-eu-electricity-produced-and-sold
consumed on the server side, for example, comparing
[7] C.Freitag,M.Berners-Lee,K.Widdicks,B.Knowles,G.S.Blair,and
different content management platforms or content A.Friday,‘‘TherealclimateandtransformativeimpactofICT:Acritique
repositories in serving the content over the network ofestimates,trends,andregulations,’’Patterns,vol.3,no.8,Aug.2022,
Art.no.100576.
to the client. Future research in server-side energy
[8] H. Ritchie, P. Rosado, and M. Roser, ‘‘Energy production and
consumptionisdirelyneeded. consumption,’’ 2020. Accessed: Jun. 24, 2025. [Online]. Available: 4) Due to the distributed nature of the web, the content https://ourworldindata.org/energy-production-consumption
andfunctionalityofasinglewebpagecanbegenerated [9] V. Rozite, E. Bertoli, and B. Reidenbach. Data Centres and Data
Transmission Networks. Accessed: Mar. 9, 2024. [Online]. Available:
in and downloaded from several distinct platforms
https://www.iea.org/energy-system/buildings/data-centres-and-data-
residingindisparatedatacenterswitheachhavingits transmission-networks
energycarbonintensitymix.Calculationsshouldtake [10] TechnicalReport,U.S.EnergyInformationAdministration,International
EnergyOutlook,Paris,France,Oct.2023.
theseintoaccount,preferablyautomatically.
[11] United Nations. Causes and Effects of Climate Change. Accessed: 5) Tobuildaproperdatabaseofwebsiteenergyconsump- Jun. 24, 2025. [Online]. Available: https://www.un.org/en/
tion in the consumer device, the test set should be climatechange/science/causes-effects-climate-change
automated using sitespeed.io—after checking that its [12] G. Micheletti, N. Raczko, C. Moise, D. Osimo, and G. Cattaneo,
‘‘European data market study 2021–2023—Final report on policy
measurementsareonparwithmanualmeasurements—
conclusions,’’EuropeanCommission,Belgium,Tech.Rep.2020-0655,
and use a large list of sites, such as in [38]. Such a Feb.2024.
databasewouldprovidetheneededhorizonforwebsite [13] R. Istrate, V. Tulus, R. N. Grass, L. Vanbever, W. J. Stark, and
G.Guillén-Gosálbez,‘‘Theenvironmentalsustainabilityofdigitalcon-
performance and give insights into the variation of
tentconsumption,’’NatureCommun.,vol.15,no.1,p.3724,May2024.
energyconsumption. [14] A.-L. Kor, C. Pattinson, I. Imam, I. AlSaleemi, and O. Omotosho,
‘‘Applications, energy consumption, and measurement,’’ in Proc. Int.
Should these issues be solved with further research,
Conf.Inf.Digit.Technol.,Jul.2015,pp.161–171.
to estimate the energy consumption of a whole website,
[15] Joulemeter. Computational Energy Measurement and Optimization—
the measurements have to be automated and run for each Microsoft Research. Accessed: Jan. 26, 2025. [Online]. Available:
distinct page and then these measurements should be https://www.microsoft.com/en-us/research/project/joulemeter-
computational-energy-measurement-and-optimization/
scaled with the number of page loads for each page. This
[16] S. Huber, L. Demetz, and M. Felderer, ‘‘A comparative study on the
information is fortunately readily available from website energy consumption of progressive web apps,’’ Inf. Syst., vol. 108,
analyticsplatforms. Sep.2022,Art.no.102017.
[17] A.Saarinen,M.Z.Farooqi,M.Pärssinen,andJ.Manner,‘‘Understanding
andmitigatingwebpagedatabloat:Causesandpreventivemeasures,’’
ACKNOWLEDGMENT SigenergyEnergyInform.Rev.,vol.4,no.5,pp.106–112,Apr.2025.
The authors would like to thank Florian Quèze, Nazım Can [18] J. Thangadurai, P. Saha, K. Rupanya, R. Naeem, A. Enriquez,
G.L.Scoccia, M. Martinez, and I. Malavolta, ‘‘Electron vs. web: A
Altınova, Fershard Irani, Andy Davies, Jukka Manner, Jari
comparative analysis of energy and performance in communication
Porras, and Petri Vuorimaa for additional research support apps,’’inQualityofInformationandCommunicationsTechnology.Cham,
andconversation. Switzerland:Springer,2024,pp.177–193.
[19] A.MiettinenandJ.K.Nurminen,‘‘Analysisoftheenergyconsumptionof
JavaScriptbasedmobilewebapplications,’’inProc.2ndInt.ICSTConf.
DECLARATIONOFCONFLICTINGINTERESTS MobileLightweightWirelessSyst.,Barcelona,Spain,2010,pp.124–135.
The authors declared no potential conflicts of interest [20] R. Mittal, A. Kansal, and R. Chandra, ‘‘Empowering developers to
estimateappenergyconsumption,’’inProc.18thAnnu.Int.Conf.Mobile
concerning the research, authorship, and/or publication of
Comput.Netw.,Aug.2012,pp.317–328.
thisarticle.
[21] C.Wilke,C.Piechnick,S.Richly,G.Püschel,S.Götz,andU.Aßmann,
‘‘Comparingmobileapplications’energyconsumption,’’inProc.28th
Annu.ACMSymp.Appl.Comput.,Mar.2013,pp.1177–1179.
REFERENCES
[22] I. Malavolta, K. Chinnappan, L. Jasmontas, S. Gupta, and
[1] T. Berners-Lee, R. Cailliau, J. Groff, and B. Pollermann, ‘‘World- K.A.K.Soltany, ‘‘Evaluating the impact of caching on the energy
wide web: The information universe,’’ Internet Res., vol. 20, no. 4, consumption and performance of progressive web apps,’’ in Proc.
pp.461–471,2010. IEEE/ACM 7th Int. Conf. Mobile Softw. Eng. Syst., Jul. 2020,
[2] Internet and Social Media Users in the World 2023. Accessed: pp.109–119.
Aug. 28, 2023. [Online]. Available: https://www.statista. [23] What is Jamstack. Accessed: Feb. 4, 2025. [Online]. Available:
com/statistics/617136/digital-population-worldwide/ https://jamstack.org/
[3] A.TaivalsaariandT.Mikkonen,‘‘Thewebasanapplicationplatform: [24] J. Vepsäläinen, A. Hellas, and P. Vuorimaa, ‘‘Implications of edge
TheSagacontinues,’’inProc.37thEUROMICROConf.Softw.Eng.Adv. computingforstaticsitegeneration,’’inProc.19thInt.Conf.WebInf.
Appl.,Aug.2011,pp.170–174. Syst.Technol.,2023,pp.223–231.
VOLUME13,2025 139015

J.Kalliola,J.Vepsäläinen:ChallengesRelatedtoApproximatingtheEnergyConsumptionofaWebsite
[25] M. Biilmann. (Apr. 2016). The New Front-end Stack. Javascript, [48] B. Poulain and S. Fraser. How Web Content Can Affect
APIs and Markup. Accessed: Feb. 4, 2025. [Online]. Available: Power Usage. Accessed: Feb. 4, 2025. [Online]. Available:
https://vimeo.com/showcase/4247343/video/163522126 https://webkit.org/blog/8970/how-web-content-can-affect-power-usage/
[26] J.Kamal,‘‘Designanddevelopmentofaheadlesscontentmanagement [49] S.-M. Laaksonen, M. Frig, P. Pulli, E. Skenderi, and S. Suppanen,
system,’’ Int. Res. J. Eng. Technol., vol. 9, no. 7, pp.697–701, 2022. ‘‘ReDime:Tiekarttakohtiresurssiviisastadigitaalistamediaa,’’Faculty
Accessed:Feb.4,2025. SocialSciences,Media-AlanTutkimuss,Finland,Tech.Rep.2024:261,
[27] T.ShanandW.Hua,‘‘TaxonomyofJavawebapplicationframeworks,’’ 2024.
inProc.IEEEInt.Conf.e-Bus.Eng.(ICEBE),Oct.2006,pp.378–385. [50] M. Tutt. (Mar. 2024). Climate Change SEO Survey: Making the
[28] J.Vepsäläinen,A.Hellas,andP.Vuorimaa,‘‘Thestateofdisappearing Web More Sustainable. Accessed: Feb. 4, 2025. [Online]. Avail-
frameworks in 2023,’’ in Proc. 19th Int. Conf. Web Inf. Syst. Tech- able: https://searchengineland.com/climate-change-seo-survey-making-
nol.,2023,pp.232–241. web-more-sustainable-438209
[29] J.Vepsäläinen,A.Hellas,andP.Vuorimaa,‘‘Theriseofdisappearing [51] F. Irani. Adapting Cloud Carbon Footprint’s Methodology to Website
frameworksinwebdevelopment,’’inProc.Int.Conf.WebEng.,2023, Carbon Estimates. Accessed: Jun. 13, 2024. [Online]. Available:
pp.319–326. https://www.fershad.com/writing/adapting-cloud-carbon-footprints-
[30] X.-A.Cao,‘‘HeadlessCMSandQWIKframeworkandtheirpracticalities methodology-to-website-carbon-estimates/#the-problem-with-models
in the future of application development,’’ M.S. thesis, Dept. Inf. [52] Alexander Dawson. (Jan. 2023). The Carbon Impact of Web
Technol.,VaasaUniv.Appl.Sciences,2023. Standards. [Online]. Available: https://websitesustainability.
[31] J. Vepsäläinen, M. Hevery, and P. Vuorimaa, ‘‘Resumability—A new com/cache/files/research23.pdf
primitive for developing web applications,’’ IEEE Access, vol. 12, [53] K.Chan-Jong-Chu,T.Islam,M.M.Exposito,S.Sheombar,C.Valladares,
pp.9038–9046,2024. O.Philippot,E.M.Grua,andI.Malavolta,‘‘Investigatingthecorrelation
[32] V. Ballamudi, K. Lal, H. Desamsetti, and S. Dekkati, ‘‘Getting between performance scores and energy consumption of mobile web
startedmodernwebdevelopmentwithnext.Js:Anindispensablereact apps,’’inProc.24thInt.Conf.Eval.AssessmentSoftw.Eng.,NewYork,
framework,’’DigitalizationSustainabilityRev.,vol.1,no.1,pp.1–11, NY,USA,Apr.2020,pp.190–199. 2021. [54] TomaszOsowski.(Oct.2022).YourWebsite’sDigitalFootprint.Toolsto
[33] B.LivshitsandE.Kiciman,‘‘Doloto:Codesplittingfornetwork-bound TrackItsCO2Emissions.Accessed:Mar.10,2024.[Online].Available:
web2.0applications,’’inProc.16thACMSIGSOFTInt.Symp.Found. https://dodonut.com/blog/digital-carbon-footprint-tools/
Softw.Eng.,Nov.2008,pp.350–360. [55] Website Carbon Calculator v3. (2025). What’s Your Site’s
[34] Jamie Indigo and Dave Smart. (2024). Page Weight. Carbon Footprint. Accessed: Jun. 27, 2025. [Online]. Available:
Accessed: Feb. 4, 2025. [Online]. Available: https://almanac. https://www.websitecarbon.com/
httparchive.org/en/2024/ [56] C.Adams,R.Baouendi,T.Frick,T.Greenwood,andD.Williams.SWD
[35] NikiTonsky.JavaScriptBloatin2024.Accessed:Feb.4,2025.[Online]. EmissionsModel(legacy).Accessed:Jul.5,2024.[Online].Available:
Available:https://tonsky.me/blog/js-bloat/ https://sustainablewebdesign.org/estimating-digital-emissions-version-
3/
[36] N.Jakopin,G.Mohr,E.Cafforio,G.Peres,M.Weber,andK.Burkhanov,
‘‘TheevolutionofdatagrowthinEurope,’’ArthurD.Little,Tech.Rep., [57] A.Davies.(Jan.21,2025).QueryonWebsitecarbon.comModelVersion. 2023. E-MailConversation.
[37] Page Weight. Accessed: Aug. 28, 2023. [Online]. Available: [58] P. Jardine and B. Thorn. Tools for Calculating Your Website’s
https://almanac.httparchive.org/en/2022/page-weight CO2 Emissions. Accessed: Apr. 7, 2024. [Online]. Available:
https://rootwebdesign.studio/articles/tools-for-calculating-your-
[38] A. Saarinen and J. Manner, ‘‘Analyysi suosituista suomessa ktetyist
websites-co2-emissions/
verkkosivuista,’’AaltoUniv.,Tech.Rep.1/2022,2022.
[59] Ecograder. Accessed: Jun. 27, 2025. [Online]. Available:
[39] M.Hirsch-Dick,S.Naumann,andA.Held,‘‘Greenwebengineering—
https://ecograder.com/
Asetofprinciplestosupportthedevelopmentandoperationof‘green’
[60] Ecograder.HowitWorks.Accessed:Mar.10,2024.[Online].Available:
websitesandtheirutilizationduringawebsite’slifecycle,’’inProc.Int.
https://ecograder.com/how-it-works
Conf.WebInf.Syst.Technol.,vol.1,Jan.2010,pp.48–55.
[61] Carbon Calculator. Accessed: Jun. 27, 2025. [Online]. Available:
[40] E. Fahlstr and F. Persson, ‘‘Sustainable web design–how much can
https://websiteemissions.com/
environmental friendly design principles improve a website’s carbon
footprint?’’ Ph.D. thesis, Dept. Software Eng., Blekinge Institute of [62] CarbonCalculator.HowDoesitWork.Accessed:Mar.16,2024.[Online].
Technology,May2023. Available:https://websiteemissions.com/howitworks
[41] S.G.Paul,A.Saha,M.S.Arefin,T.Bhuiyan,A.A.Biswas,A.W.Reza, [63] Beacon. Accessed: Jun. 26, 2024. [Online]. Available:
N.M.Alotaibi,S.A.Alyami,andM.A.Moni,‘‘Acomprehensivereview https://digitalbeacon.co/
ofgreencomputing:Past,present,andfutureresearch,’’IEEEAccess, [64] Beacon.FrequentlyAskedQuestions.Accessed:Mar.10,2024.[Online].
vol.11,pp.87445–87494,2023. Available:https://digitalbeacon.co/faqs
[42] (Dec. 2024). Usage Statistics of Content Management Systems. [65] Cabin | Privacy-First, Google Analytics Alternative. Accessed:
Accessed: Feb. 4, 2025. [Online]. Available: https://w3techs.com/ Jun.27,2025.[Online].Available:https://withcabin.com/
technologies/overview/content_management [66] Cabin.(Aug.2022).CarbonTracking.Accessed:Mar.10,2024.[Online].
[43] E.Yanney,T.W.Simpson,andK.S.Boadi,‘‘Usingperformancemetrics Available:https://docs.withcabin.com/carbon-tracking.htm
toguidetheselectionofawebsitecontentmanagementsystem—Thecase [67] EcoPing. Accessed: Jun. 27, 2025. [Online]. Available:
ofJoomla,DrupalandWordPress,’’Inf.Knowl.Manage.,vol.13,no.1, https://ecoping.earth/
pp.36–47,2023. [68] Carbonalyser. Accessed: Jun. 27, 2025. [Online]. Available:
[44] Ahmed Ginani. (Jul. 20, 2023). CMS Performance Monitoring: https://addons.mozilla.org/en-U.S./firefox/addon/carbonalyser/
IdentifyingBottlenecksandEnhancingSpeed.Accessed:Feb.4,2025. [69] R.Hanna,G.Roussile,andM.Efoui-Hess.(Jan.2020).Carbonalyser
[Online]. Available: https://medium.com/@elijah_williams_agc/cms- by the Shift Project. Accessed: Apr. 2, 2025. [Online]. Available:
performance-monitoring-identifying-bottlenecks-and-enhancing-speed- https://addons.mozilla.org/en-U.S./firefox/addon/carbonalyser/
1fab06e87962 [70] H.Ferreboeuf,F.O.Berthoud,P.Bihouix,P.Fabre,D.Kaplan,L.Lef
[45] T.CernyandM.J.Donahoo,‘‘Onenergyimpactofwebuserinterface vre,A.Monnin,O.Ridoux,S.Vaija,M.Vautier,X.Verne,A.Ducass,
approaches,’’ClusterComput.,vol.19,no.4,pp.1853–1863,Dec.2016. M.Efoui-Hess,andZ.Kahraman,‘‘LeanICT—Towardsdigitalsobriety,’’
[46] Alisa Bonsignore. (Feb. 2024). Designing Sustainable TheShiftProject,France,Mar.2019.
Content. Accessed: Feb. 4, 2025. [Online]. Available: [71] Offset Mode-Chrome Web Store. Accessed: Jun. 27, 2025.
https://www.buttonconf.com/blog/designing-sustainable-content [Online]. Available: https://chromewebstore.google.com/detail/offset-
[47] D. Mytton, D. Lundén, and J. Malmodin, ‘‘Network energy use not mode/pecnblnambldmfgbihmkgapcpkhoepfj
directly proportional to data volume: The power model approach for [72] (Apr. 2022). Offset Mode. Accessed: Apr. 2, 2025. [Online].
morereliablenetworkenergyconsumptioncalculations,’’J.Ind.Ecology, Available: https://chromewebstore.google.com/detail/offset-
vol.28,no.4,pp.966–980,Jun.2024. mode/pecnblnambldmfgbihmkgapcpkhoepfj
139016 VOLUME13,2025

J.Kalliola,J.Vepsäläinen:ChallengesRelatedtoApproximatingtheEnergyConsumptionofaWebsite
[73] Tree Canada. (Nov. 2022). Offset Mode (80s). Accessed: [96] D. Mytton. (Sep. 2022). Measuring Website Energy Consumption
Apr. 2, 2025. [Online]. Available: https://www.adforum.com/creative- via Browser Profiling. Accessed: Feb. 4, 2025. [Online]. Available:
work/ad/player/34669145/offset-mode-80s/tree-canada https://davidmytton.blog/measuring-website-energy-consumption/
[74] GreenFrame–MeasuretheCarbonFootprintofYourWebsite.Accessed: [97] F.Quze.(Dec.12,2024).QueryonFirefoxProfiler.E-MailConversation.
Jun.27,2025.[Online].Available:https://greenframe.io/ [98] F. Quze. (Jun. 24, 2025). Query on Firefox Profiler Power Sampling
Functionality.E-Mailconversation.
| [75] Measure | and | Reduce | Your Website’s | CO2 | Emissions. | Accessed: | | | | | | |
| ------------ | --- | ------ | -------------- | --- | ---------- | --------- | --- | --- | --- | --- | --- | --- |
[99] J.Dodge,T.Prewitt,R.TachetdesCombes,E.Odmark,R.Schwartz,
Apr.2,2025.[Online].Available:https://greenframe.io/
E.Strubell,A.S.Luccioni,N.A.Smith,N.DeCario,andW.Buchanan,
| [76] Fershad | Irani. (Dec. | 2023). | Why WebPerf | ToolsShould | | beReporting | | | | | | |
| ------------ | ------------ | ------ | ----------- | ----------- | --- | ----------- | --- | --- | --- | --- | --- | --- |
WebsiteCarbonEmissions.Accessed:Dec.13,2023.[Online].Available: ‘‘MeasuringthecarbonintensityofAIincloudinstances,’’inProc.ACM
https://calendar.perfplanet.com/2023/why-web-perf-tools-should-be- Conf.FairnessAccountabilityTransparency,Jun.2022,pp.1877–1894.
reporting-website-carbon-emissions/ [100] S.UdaniandJ.Smith,‘‘Thepowerbroker:Intelligentpowermanagement
| | | | | | | | for mobile | computers,’’ | Univ. | Pennsylvani, | Washington, | DC, USA, |
| --------------- | ------ | --------- | ---- | -------- | --------- | ---------- | ---------- | ------------ | ----- | ------------ | ----------- | -------- |
| [77] GreenFrame | Model. | Accessed: | Jul. | 5, 2024. | [Online]. | Available: | | | | | | |
Tech.Rep.MS-CIS-96-12,1996.
https://github.com/marmelab/greenframe-cli/blob/main/src/model/
[101] A.MahesriandV.Vardhan,‘‘Powerconsumptionbreakdownonamodern
README.md
[78] F.Irani.CuriousAboutDrivingtheTransitiontoaFossil-freeInternet? laptop,’’inProc.4thInt.WorkshopPower-AwareComput.Syst.,2005,
| Here’s | How CO2.Js | Can | Help. Accessed: | Mar. | 16, 2024. | [Online]. | pp.165–180. | | | | | |
| ------ | ---------- | --- | --------------- | ---- | --------- | --------- | ----------- | --- | --- | --- | --- | --- |
[102] B.Prieto,J.J.Escobar,J.C.Gómez-López,A.F.Díaz,andT.Lampert,
Available:https://www.thegreenwebfoundation.org/news/curious-about-
| | | | | | | | ‘‘Energy | efficiency | of personal | computers: | A comparative | analysis,’’ |
| --- | --- | --- | --- | --- | --- | --- | -------- | ---------- | ----------- | ---------- | ------------- | ----------- |
driving-the-transition-to-a-fossil-free-internet-heres-how-co2-js-can-
Sustainability,vol.14,no.19,p.12829,Oct.2022.
help/
[103] Z.Zhang,‘‘AnalysisoftheadvantagesoftheM1CPUanditsimpacton
| [79] Methodologies | | for Calculating | | Website | Carbon. | Accessed: | | | | | | |
| ------------------ | --- | --------------- | --- | ------- | ------- | --------- | --- | --- | --- | --- | --- | --- |
Mar. 16, 2024. [Online]. Available: https://developers. thefuturedevelopmentofapple,’’inProc.2ndInt.Conf.BigDataArtif.
Intell.Softw.Eng.(ICBASE),Sep.2021,pp.732–735.
thegreenwebfoundation.org/co2js/explainer/methodologies-for-
| | | | | | | | [104] Introduction | to | Sitespeed.io | and | Web Performance | Testing. |
| --- | --- | --- | --- | --- | --- | --- | ------------------ | --- | ------------ | --- | --------------- | -------- |
calculating-website-carbon/
| | | | | | | | Accessed: | Jan. 27, | 2025. [Online]. | Available: | https://www.sitespeed. | |
| -------- | ----- | --------------- | --- | ------- | -------- | --------- | --------- | -------- | --------------- | ---------- | ---------------------- | --- |
| [80] The | Green | Web Foundation. | | CO2.Js: | Methods. | Accessed: | | | | | | |
io/documentation/sitespeed.io/introduction/
| Jun. | 24, | 2025. | [Online]. | Available: | https://developers. | | | | | | | |
| ---- | --- | ----- | --------- | ---------- | ------------------- | --- | --- | --- | --- | --- | --- | --- |
[105] N.C.Altınova.ImproveHowWeComputeThePowerConsumptionNum-
thegreenwebfoundation.org/co2js/methods/ bersFromTheFirefoxProfilerOutput.Accessed:Jan.9,2025.[Online].
[81] EstimatingDigitalEmissions.Accessed:Jul.5,2024.[Online].Available: Available:https://github.com/sitespeedio/browsertime/pull/2220
https://sustainablewebdesign.org/estimating-digital-emissions/
[106] CoreWebVitals|Web.dev—Web.dev.Accessed:Feb.4,2025.[Online].
[82] J.Malmodin,N.Lövehagen,P.Bergmark,andD.Lundén,‘‘ICTsector
Available:https://web.dev/explore/learn-core-web-vitals
electricityconsumptionandgreenhousegasemissions–2020outcome,’’
[107] N.Wehner,M.Amir,M.Seufert,R.Schatz,andT.Hoßfeld,‘‘Avital
Telecomm.Policy,vol.48,no.3,Apr.2024,Art.no.102701.
improvement?RelatingGoogle’scorewebvitalstoactualwebQoE,’’in
[83] A.S.G.Andrae,‘‘Newperspectivesoninternetelectricityusein2030,’’ Proc.14thInt.Conf.QualityMultimediaExper.(QoMEX),Sep.2022,
| Eng.Appl.Sci.Lett.,vol.3,no.2,pp.19–31,Dec.2020. | | | | | | | pp.1–6. | | | | | |
| ------------------------------------------------ | --- | --- | --- | --- | --- | --- | ------- | --- | --- | --- | --- | --- |
[84] Fershad Irani. (Jun. 2024). Understand the Latest Sustainable Web [108] E.Viciana,A.Alcayde,F.G.Montoya,R.Baños,F.M.Arrabal-Campos,
| Design | Model | Update. | | | | | | | | | | |
| ------ | ----- | ------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
Accessed: Jul. 7, 2024. [Online]. Avail- A.Zapata-Sierra,andF.Manzano-Agugliaro,‘‘OpenZmeter:Anefficient
able: https://www.thegreenwebfoundation.org/news/understanding-the-
low-costenergysmartmeterandpowerqualityanalyzer,’’Sustainability,
latest-sustainable-web-design-model-update/ vol.10,no.11,p.4038,Nov.2018.
[85] WhyDoesGreenHostingMatter?.Accessed:Mar.12,2024.[Online]. [109] A. F. Díaz, B. Prieto, J. J. Escobar, and T. Lampert, ‘‘Vampire:
Available: https://www.thegreenwebfoundation.org/support/why-does- A smart energy meter for synchronous monitoring in a distributed
green-hosting-matter/ computer system,’’ J. Parallel Distrib. Comput., vol. 184, Feb. 2024,
[86] (Jan. 2024). What We Accept As Evidence of Green Power. Art.no.104794.
Accessed: Mar. 16, 2024. [Online]. Available: https://www. [110] F. Quze, ‘‘Firefox power profiling—A powerful visualization of web
thegreenwebfoundation.org/what-we-accept-as-evidence-of-green- sustainability,’’inProc.FOSDEM,Belgium,2024.
| power/ | | | | | | | [111] Most Used | Web | Frameworks | | Among Developers | 2024. |
| ------ | --- | --- | --- | --- | --- | --- | --------------- | --- | ---------- | --- | ---------------- | ----- |
[87] International Energy Outlook 2023, IEO, U.S. Energy Information Accessed: Feb. 5, 2025. [Online]. Available: https://www.statista.
Administration,Washington,DC,USA,Oct.2023. com/statistics/1124699/worldwide-developer-survey-most-used-
frameworks-web/
[88] Y.Vasilev.HowToMeasureYourWebsite’sCO2Emissions?.Accessed:
Dec.10,2023.[Online].Available:https://www.linkedin.com/pulse/how-
measure-your-websites-co2-emissions-yasen-jason-vasilev- JANNE KALLIOLA received the M.S. degree
| ix1te/ | | | | | | | | | in computer | engineering | from | the Department |
| ------ | --- | --- | --- | --- | --- | --- | --- | --- | ----------- | ----------- | ---- | -------------- |
[89] C.SchneiderandF.Zaninotto.DigitalCarbonFootprint:TheCurrent of Computer Science, Helsinki University of
Technology,Finland,in2000,andtheLicentiate
StateofMeasuringTools.Accessed:Apr.6,2024.[Online].Available:
| | | | | | | | | | of Technology | degree | in computer | science from |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | ------------- | ------ | ----------- | ------------ |
https://marmelab.com/blog/2022/04/05/greenframe-compare.html
HelsinkiUniversityofTechnology,in2001.Heis
| [90] Youen | Ch. (Sep. | 2023). | State of the | Art and | Limit of | Measuring the | | | | | | |
| ---------- | --------- | ------ | ------------ | ------- | -------- | ------------- | --- | --- | --- | --- | --- | --- |
FootprintofaContentWebsite—Version2023.Accessed:Feb.4,2025. currently pursuing the Ph.D. degree with Aalto
[Online]. Available: https://www.lewebvert.fr/en/blog/2023-09-06-etat- University. He is the Founder and the Chief
de-lart-site-web-contenu-v2/ Growth Officer of Exove. His research interests
[91] TomGreenwood.WhyDoEstimatesforInternetEnergyConsumption include web development, energy-efficient soft-
Vary So Drastically. Accessed: Jan. 14, 2024. [Online]. Available: wareandarchitectures,andenergyconsumptionintheICTindustry.Heis
https://www.wholegraindigital.com/blog/website-energy-consumption/ theChairpersonoftheBoardofCodefromFinlandAssociation.
| [92] (Oct. | 2023). | Why | We Don’t | Report | Website | Carbon | | | | | | |
| ---------- | ------ | --- | -------- | ------ | ------- | ------ | --- | --- | --- | --- | --- | --- |
Emissions. Accessed: Dec. 13, 2023. [Online]. Available: JUHOVEPSÄLÄINENreceivedtheD.Sc.degree
https://www.debugbear.com/blog/website-carbon-emissions in computer science from Aalto University,
[93] IntroducingtheWebsiteCarbonRatingSystem.Accessed:Mar.15,2024. Finland, in 2025. As a Core Team Member,
hehascontributedtoopen-sourceprojects,such
| [Online]. | Available: | https://www.websitecarbon.com/introducing-the- | | | | | | | | | | |
| --------- | ---------- | ---------------------------------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
asBlenderandWebpack,andpublishestechnical
website-carbon-rating-system/
| | | | | | | | | | literature | under the | brand SurviveJS, | while run- |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | ---------- | --------- | ---------------- | ---------- |
[94] SLecorney,R.Zweifel,andJ.Taylor,‘‘Reviewofwebanalytictools
ningaconferenceseriescalledFutureFrontend.
foreco-conception,’’AuthoreaPreprint,Dec.2023.[Online].Available:
https://www.researchgate.net/publication/376702697_Review_ His research interests include web development,
of_Web_Analytic_tools_for_eco-conception web performance, and hybrid models for web
[95] F. Quze, ‘‘Firefox power profiling—Visualizing web app efficiency,’’ applicationdevelopment.
GreenCodingSummit,Berlin,Nov.2023.
| VOLUME13,2025 | | | | | | | | | | | | 139017 |
| ------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ------ |

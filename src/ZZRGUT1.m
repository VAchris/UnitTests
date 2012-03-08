GMPA1UT ;; 
 ;;;Problem List;;02/21/12
 S IO=""
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("GMPA1UT")
 Q
 ;
STARTUP ; 
 S DUZ=1,DUZ(0)="@",IO="",U="^"
 S DT=$P($$HTFM^XLFDT($H),".")
 S LSTNAME="PList"_DT
 S CATNAME="Category"_DT
 S LOC=$P(^SC(0),U,3)
 S USER="1"
 S LSTMAX=$P(^GMPL(125,0),U,3)
 S LSTCNT=$P(^GMPL(125,0),U,4)
 S CATMAX=$P(^GMPL(125.11,0),U,3)
 S CATCNT=$P(^GMPL(125.11,0),U,4)
 Q
 ;
SETUP ; 
 ; Check if List name already exists. 
 I $D(^GMPL(125,"B",LSTNAME))=0 Q
 S LSTNAME=LSTNAME_"1" D SETUP 
 Q
 ;
SHUTDOWN ;
 Q
 ;
NEWLST ; Test New list
 ;
 S LST=$$NEWLST^GMPLAPI1(LSTNAME,"W",.ERR)
 D CHKEQ^XTMUNIT(0,+LST,"List already exists")
 D CHKEQ^XTMUNIT("INVALIDPARAM",$P(@ERR@(1),U,1),"INVALIDPARAM GMPLLOC expected")
 ;
 K @ERR
 S LST=$$NEWLST^GMPLAPI1("",,.ERR)
 D CHKEQ^XTMUNIT(0,+LST,"List already exists")
 D CHKEQ^XTMUNIT("INVALIDPARAM",$P(@ERR@(1),U,1),"INVALIDPARAM GMPLLST expected")
 ;
 K @ERR
 S LST=$$NEWLST^GMPLAPI1(LSTNAME,LOC+1,.ERR)
 D CHKEQ^XTMUNIT(0,+LST,"List already exists")
 D CHKEQ^XTMUNIT("LOCNOTFOUND",$P(@ERR@(1),U,1),"LOCNOTFOUND expected")
 ;
 K @ERR
 S LST=$$NEWLST^GMPLAPI1("PL",,.ERR)
 D CHKEQ^XTMUNIT(0,+LST,"List already exists")
 D CHKEQ^XTMUNIT("INVALIDPARAM",$P(@ERR@(1),U,1),"INVALIDPARAM GMPLLST expected (too short name)")
 ;
 N LNGNAME S LNGNAME="L" K @ERR
 F I=1:1:30 S LNGNAME=LNGNAME_"L"
 S LST=$$NEWLST^GMPLAPI1(LNGNAME,,.ERR)
 D CHKEQ^XTMUNIT(0,+LST,"List already exists")
 D CHKEQ^XTMUNIT("INVALIDPARAM",$P(@ERR@(1),U,1),"INVALIDPARAM GMPLLST expected (too long name)")
 ;
 K @ERR
 S LST=$$NEWLST^GMPLAPI1(LSTNAME,LOC,.ERR)
 D CHKEQ^XTMUNIT(LSTMAX+1,+LST,"INCORRECT LIST IEN")
 D CHKTF^XTMUNIT($D(@ERR)=0,"No error expected")
 D CHKEQ^XTMUNIT(LSTMAX+1,$P(^GMPL(125,0),U,3),"INCORRECT MOST RECENTLY IEN")
 D CHKEQ^XTMUNIT(LSTCNT+1,$P(^GMPL(125,0),U,4),"INCORRECT ENTRIES COUNT")
 D CHKEQ^XTMUNIT("",^GMPL(125,"B",LSTNAME,+LST),"INCORRECT CROSS-REFERENCE")
 D CHKEQ^XTMUNIT(LSTNAME_U_U_LOC,^GMPL(125,+LST,0),"INCORRECT LIST DATA")
 ;
 K @ERR
 S LST=$$NEWLST^GMPLAPI1(LSTNAME,LOC,.ERR)
 D CHKEQ^XTMUNIT(LSTMAX+1,+LST,"INCORRECT EXISTING LIST IEN")
 D CHKEQ^XTMUNIT("LISTEXIST",$P(@ERR@(1),U,1),"LISTEXIST expected")
 Q
 ;
ASSUSR ; Test Assign list to users (ASSGNUSR)
 K @ERR
 D ASSGNUSR^GMPLAPI1("A","",.ERR)
 D CHKEQ^XTMUNIT("INVALIDPARAM",$P(@ERR@(1),U,1),"INVALIDPARAM GMPLLST expected")
 ;
 K @ERR
 D ASSGNUSR^GMPLAPI1(+LST+1,"",.ERR)
 D CHKEQ^XTMUNIT("LISTNOTFOUND",$P(@ERR@(1),U,1),"LISTNOTFOUND expected")
 ;
 K @ERR
 D ASSGNUSR^GMPLAPI1(+LST,"^USER^",.ERR)
 D CHKEQ^XTMUNIT("INVALIDPARAM",$P(@ERR@(1),U,1),"INVALIDPARAM USER expected")
 ;
 K @ERR
 D ASSGNUSR^GMPLAPI1(+LST,$P(^VA(200,0),U,3)+1,.ERR)
 D CHKEQ^XTMUNIT("PROVNOTFOUND",$P(@ERR@(1),U,1),"PROVNOTFOUND expected")
 ;
 K @ERR
 D ASSGNUSR^GMPLAPI1(+LST,USER,.ERR)
 D CHKEQ^XTMUNIT(^VA(200,USER,125),U_+LST,"INCORRECT USER ASSIGNED LIST DATA")
 D CHKTF^XTMUNIT($D(@ERR)=0,"No error expected")
 ;
 Q
 ;
REMUSR ; Test Remove list from users
 K @ERR
 D ASSGNUSR^GMPLAPI1("A",USER,.ERR)
 D CHKEQ^XTMUNIT("INVALIDPARAM",$P(@ERR@(1),U,1),"INVALIDPARAM GMPLLST expected")
 ;
 K @ERR
 D ASSGNUSR^GMPLAPI1(+LST+1,USER,.ERR)
 D CHKEQ^XTMUNIT("LISTNOTFOUND",$P(@ERR@(1),U,1),"LISTNOTFOUND expected")
 ;
 K @ERR
 D ASSGNUSR^GMPLAPI1(+LST,"^USER^",.ERR)
 D CHKEQ^XTMUNIT("INVALIDPARAM",$P(@ERR@(1),U,1),"INVALIDPARAM GMPLUSER expected")
 ;
 K @ERR
 D ASSGNUSR^GMPLAPI1(+LST,$P(^VA(200,0),U,3)+1,.ERR)
 D CHKEQ^XTMUNIT("PROVNOTFOUND",$P(@ERR@(1),U,1),"PROVNOTFOUND expected")
 ;
 K @ERR
 D REMUSR^GMPLAPI1(+LST,USER,.ERR)
 D CHKEQ^XTMUNIT(^VA(200,USER,125),U,"INCORRECT USER ASSIGNED LIST DATA")
 ;
 Q
 ;
DELULST ;
 ;
 K @ERR
 D DELSLST^GMPLAPI1("A",,.ERR)
 D CHKEQ^XTMUNIT("INVALIDPARAM",$P(@ERR@(1),U,1),"INVALIDPARAM GMPLLST expected")
 ;
 K @ERR
 D DELSLST^GMPLAPI1(+LST+1,,.ERR)
 D CHKEQ^XTMUNIT("LISTNOTFOUND",$P(@ERR@(1),U,1),"LISTNOTFOUND expected")
 ;
 K @ERR
 D DELSLST^GMPLAPI1(+LST,,.ERR)
 D CHKEQ^XTMUNIT("LISTUSED",$P(@ERR@(1),U,1),"LISTUSED expected")
 Q
 ;
DELLST ; 
 ;
 K @ERR
 S:LSTCNT="" LSTCNT=0
 D DELSLST^GMPLAPI1(+LST,,.ERR)
 D CHKTF^XTMUNIT($D(@ERR)=0,"List deleted. No error expected.")
 D CHKEQ^XTMUNIT(LSTMAX,$P(^GMPL(125,0),U,3),"INCORRECT MOST RECENTLY IEN")
 D CHKEQ^XTMUNIT(LSTCNT,$P(^GMPL(125,0),U,4),"INCORRECT ENTRIES COUNT")
 D CHKTF^XTMUNIT($D(^GMPL(125,"B",LSTNAME))=0,"INCORRECT CROSS-REFERENCE")
 D CHKTF^XTMUNIT($D(^GMPL(125,+LST))=0,"INCORRECT LIST IEN")
 Q
 ;
NEWCAT
 S CAT=$$NEWCAT^GMPLAPI1("",.ERR)
 D CHKEQ^XTMUNIT(0,+CAT,"Category already exists")
 D CHKEQ^XTMUNIT("INVALIDPARAM",$P(@ERR@(1),U,1),"INVALIDPARAM GMPLGRP expected")
 ;
 K @ERR
 S CAT=$$NEWCAT^GMPLAPI1("CA",.ERR)
 D CHKEQ^XTMUNIT(0,+CAT,"Category already exists")
 D CHKEQ^XTMUNIT("INVALIDPARAM",$P(@ERR@(1),U,1),"INVALIDPARAM GMPLGRP expected (too short name)")
 ;
 N LNGNAME S LNGNAME="L" K @ERR
 F I=1:1:30 S LNGNAME=LNGNAME_"L"
 S CAT=$$NEWCAT^GMPLAPI1(LNGNAME,.ERR)
 D CHKEQ^XTMUNIT(0,+CAT,"Category already exists")
 D CHKEQ^XTMUNIT("INVALIDPARAM",$P(@ERR@(1),U,1),"INVALIDPARAM GMPLGRP expected (too long name)")
 ;
 K @ERR
 S CAT=$$NEWCAT^GMPLAPI1(CATNAME,.ERR)
 D CHKEQ^XTMUNIT(CATMAX+1,+CAT,"INCORRECT CATEGORY IEN")
 D CHKTF^XTMUNIT($D(@ERR)=0,"No error expected")
 D CHKEQ^XTMUNIT(CATMAX+1,$P(^GMPL(125.11,0),U,3),"INCORRECT MOST RECENTLY IEN")
 D CHKEQ^XTMUNIT(CATCNT+1,$P(^GMPL(125.11,0),U,4),"INCORRECT ENTRIES COUNT")
 D CHKEQ^XTMUNIT("",^GMPL(125.11,"B",CATNAME,+CAT),"INCORRECT CROSS-REFERENCE")
 D CHKEQ^XTMUNIT(CATNAME,^GMPL(125.11,+CAT,0),"INCORRECT LIST DATA")
 ;
 K @ERR
 S CAT=$$NEWCAT^GMPLAPI1(CATNAME,.ERR)
 D CHKEQ^XTMUNIT(CATMAX+1,+CAT,"INCORRECT EXISTING LIST IEN")
 D CHKEQ^XTMUNIT("CATEGEXIST",$P(@ERR@(1),U,1),"CATEGEXIST expected")
 Q
 ;
DELUCAT ;
 ;
 K @ERR
 D DELCAT^GMPLAPI1("A",,.ERR)
 D CHKEQ^XTMUNIT("INVALIDPARAM",$P(@ERR@(1),U,1),"INVALIDPARAM GMPLLST expected")
 ;
 K @ERR
 D DELCAT^GMPLAPI1(+CAT+1,,.ERR)
 D CHKEQ^XTMUNIT("CATNOTFOUND",$P(@ERR@(1),U,1),"CATNOTFOUND expected")
 ;
 K @ERR
 D DELCAT^GMPLAPI1(+CAT,,.ERR)
 D CHKEQ^XTMUNIT("LISTUSED",$P(@ERR@(1),U,1),"LISTUSED expected")
 Q
 ;
DELCAT ; 
 ;
 K @ERR
 S:CATCNT="" CATCNT=0
 D DELCAT^GMPLAPI1(+CAT,,.ERR)
 D CHKTF^XTMUNIT($D(@ERR)=0,"Category deleted. No error expected.")
 D CHKEQ^XTMUNIT(CATMAX,$P(^GMPL(125.11,0),U,3),"INCORRECT MOST RECENTLY IEN")
 D CHKEQ^XTMUNIT(CATCNT,$P(^GMPL(125.11,0),U,4),"INCORRECT ENTRIES COUNT")
 D CHKTF^XTMUNIT($D(^GMPL(125.11,"B",CATNAME))=0,"INCORRECT CROSS-REFERENCE")
 D CHKTF^XTMUNIT($D(^GMPL(125.11,+CAT))=0,"INCORRECT LIST IEN")
 Q
 ;
XTENT 
 ;;NEWLST;Tests list creation
 ;;ASSUSR;Tests user assigned list
 ;;NEWCAT;Tests category creation
 ;;DELUCAT;
 ;;DELCAT;
 ;;DELULST;Used list cannot be deleted, depend on ASSUSR
 ;;REMUSR;Remove assigned list from user
 ;;DELLST;Tests physical removal of list, depend on REMUSR
 Q
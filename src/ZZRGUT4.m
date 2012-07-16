ZZRGUT4 ;RGI/VSL - Unit Tests - Problem List ;4/24/12
 ;;1.0;UNIT TEST;;Apr 25, 2012;Build 1;
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZRGUT4")
 TROLLBACK
 Q
 ;
STARTUP ; 
 S U="^"
 S DT=$P($$HTFM^XLFDT($H),".")
 S LSTNAME="List"_DT
 S CATNAME="Diabetes "_DT
 S LOC=$P(^SC(0),U,3)
 S USER="1"
 F IN=1:1:10 S %=$$NEWLST^GMPLAPI1(.RET,"TestList"_IN)
 F IN=1:1:10 S %=$$NEWCAT^GMPLAPI1(.RET,"TestCateg"_IN)
 D ADDLIST(.LIST)
 S LSTCNT=$P(^GMPL(125,0),U,4)
 S LSTLAST=$P(^GMPL(125,0),U,3)
 S LSTCLAST=$P(^GMPL(125.1,0),U,3)
 S CATCNT=$P(^GMPL(125.11,0),U,4)
 S CATLAST=$P(^GMPL(125.11,0),U,3)
 S PROBLAST=$P(^GMPL(125.12,0),U,3)
 S USRLAST=$P(^VA(200,0),U,3)
 S %=$$ASSUSR^GMPLAPI6(.RETURN,LSTLAST,DUZ)
 Q
 ;
SETUP ; 
 Q
 ;
SHUTDOWN ;
 Q
 ;
ADDLIST(RETURN) ;
 N NLST,NCAT
 S TARGET="^TMP(""GMPLLST"",$J)"
 S %=$$NEWLST^GMPLAPI1(.NLST,LSTNAME,LOC)
 S %=$$NEWCAT^GMPLAPI1(.NCAT,CATNAME)
 N TARGET K ^TMP("GMPLLST",$J)
 S ^TMP("GMPLLST",$J,0)=1
 S ^TMP("GMPLLST",$J,"0001N")="1^33572^Diabetes Insipidus^253.5"
 M TARGET=^TMP("GMPLLST",$J)
 S %=$$SAVGRP^GMPLAPI1(.RETURN,+NCAT,.TARGET)
 K ^TMP("GMPLIST",$J)
 S TARGET="^TMP(""GMPLIST"",$J)"
 S ^TMP("GMPLIST",$J,0)=1
 S ^TMP("GMPLIST",$J,"0001N")="1"_U_NCAT_U_"1"
 M TARGET=^TMP("GMPLIST",$J)
 S %=$$SAVLST^GMPLAPI1(.RETURN,+NLST,.TARGET)
 S RETURN("LST")=NLST
 S RETURN("CAT")=NCAT
 Q
 ;
GETULST ;
 N RETURN
 S RET=$$GETULST^GMPLAPI6(.RETURN)
 D CHKEQ^XTMUNIT(0,RET,"Incorrect return")
 D CHKEQ^XTMUNIT("INVPARAM^Invalid parameter value - USER",RETURN(0),"INVPARAM - USER expected")
 ;
 K RETURN
 S RET=$$GETULST^GMPLAPI6(.RETURN,USRLAST+1)
 D CHKEQ^XTMUNIT(0,RET,"Incorrect return.")
 D CHKEQ^XTMUNIT("PROVNFND",$P(RETURN(0),U,1),"PROVNFND expected")
 ;
 K RETURN
 S RET=$$GETULST^GMPLAPI6(.RETURN,DUZ)
 D CHKEQ^XTMUNIT(1,RET,"Incorrect return.")
 D CHKEQ^XTMUNIT($P($G(^VA(200,DUZ,125)),U,2),+RETURN,"Incorrect assigned list")
 Q
 ;
GETCLST ;
 N RETURN
 S RET=$$GETCLST^GMPLAPI6(.RETURN)
 D CHKEQ^XTMUNIT(0,RET,"Incorrect return")
 D CHKEQ^XTMUNIT("INVPARAM^Invalid parameter value - GMPCLIN",RETURN(0),"INVPARAM - GMPCLIN expected")
 ;
 K RETURN
 S RET=$$GETCLST^GMPLAPI6(.RETURN,USRLAST+1)
 D CHKEQ^XTMUNIT(0,RET,"Incorrect return.")
 D CHKEQ^XTMUNIT("LOCNFND",$P(RETURN(0),U,1),"PROVNFND expected")
 ;
 K RETURN
 S RET=$$GETCLST^GMPLAPI6(.RETURN,LOC)
 D CHKEQ^XTMUNIT(1,RET,"Incorrect return.")
 D CHKEQ^XTMUNIT($O(^GMPL(125,"C",+LOC,0)),+RETURN,"Incorrect assigned list")
 Q
 ;
VALLIST ;
 NEW RET,RETURN
 S RET=$$VALLIST^GMPLAPI6(.RETURN)
 D CHKEQ^XTMUNIT(0,RET,"Incorrect return")
 D CHKEQ^XTMUNIT("INVPARAM^Invalid parameter value - LIST",RETURN(0),"INVPARAM - LIST expected.")
 ;
 K RETURN
 S RET=$$VALLIST^GMPLAPI6(.RETURN,LSTLAST+1)
 D CHKEQ^XTMUNIT(0,RET,"Incorrect return")
 D CHKEQ^XTMUNIT("LISTNFND",$P(RETURN(0),U,1),"LISTNFND expected.")
 ;
 K RETURN
 S RET=$$VALLIST^GMPLAPI6(.RETURN,LSTLAST)
 D CHKEQ^XTMUNIT(1,RET,"Incorrect return")
 D CHKEQ^XTMUNIT(1,RETURN,"Incorrect list validation result.")
 ;
 Q
 ;
ASSUSR ;
 N RET,RETURN
 S RET=$$ASSUSR^GMPLAPI6(.RETURN)
 D CHKEQ^XTMUNIT(0,RET,"Incorrect return")
 D CHKEQ^XTMUNIT("INVPARAM^Invalid parameter value - GMPLLST",RETURN(0),"INVPARAM - GMPLLST expected.")
 ;
 K RET,RETURN
 S RET=$$ASSUSR^GMPLAPI6(.RETURN,LSTLAST)
 D CHKEQ^XTMUNIT(0,RET,"Incorrect return")
 D CHKEQ^XTMUNIT("INVPARAM^Invalid parameter value - GMPLUSER",RETURN(0),"INVPARAM - GMPLUSER expected.")
 ;
 K RET,RETURN
 S RET=$$ASSUSR^GMPLAPI6(.RETURN,LSTLAST+1)
 D CHKEQ^XTMUNIT(0,RET,"Incorrect return")
 D CHKEQ^XTMUNIT("LISTNFND",$P(RETURN(0),U,1),"LISTNFND expected.")
 ;
 K RET,RETURN
 S RET=$$ASSUSR^GMPLAPI6(.RETURN,LSTLAST,USRLAST+1)
 D CHKEQ^XTMUNIT(0,RET,"Incorrect return")
 D CHKEQ^XTMUNIT("PROVNFND",$P(RETURN(0),U,1),"PROVNFND expected.")
 ;
 K RET,RETURN
 S RET=$$ASSUSR^GMPLAPI6(.RETURN,LSTLAST,DUZ)
 D CHKEQ^XTMUNIT(1,RET,"Incorrect return")
 D CHKEQ^XTMUNIT($P(^VA(200,DUZ,125),U,2),LSTLAST,"Incorrect user assigned list.")
 ;
 Q
 ;
REMUSR ;
 N RET,RETURN
 S RET=$$REMUSR^GMPLAPI6(.RETURN)
 D CHKEQ^XTMUNIT(0,RET,"Incorrect return")
 D CHKEQ^XTMUNIT("INVPARAM^Invalid parameter value - GMPLLST",RETURN(0),"INVPARAM - GMPLLST expected.")
 ;
 K RET,RETURN
 S RET=$$REMUSR^GMPLAPI6(.RETURN,LSTLAST)
 D CHKEQ^XTMUNIT(0,RET,"Incorrect return")
 D CHKEQ^XTMUNIT("INVPARAM^Invalid parameter value - GMPLUSER",RETURN(0),"INVPARAM - GMPLUSER expected.")
 ;
 K RET,RETURN
 S RET=$$REMUSR^GMPLAPI6(.RETURN,LSTLAST+1)
 D CHKEQ^XTMUNIT(0,RET,"Incorrect return")
 D CHKEQ^XTMUNIT("LISTNFND",$P(RETURN(0),U,1),"LISTNFND expected.")
 ;
 K RET,RETURN
 S RET=$$REMUSR^GMPLAPI6(.RETURN,LSTLAST,USRLAST+1)
 D CHKEQ^XTMUNIT(0,RET,"Incorrect return")
 D CHKEQ^XTMUNIT("PROVNFND",$P(RETURN(0),U,1),"PROVNFND expected.")
 ;
 K RET,RETURN
 S RET=$$REMUSR^GMPLAPI6(.RETURN,LSTLAST,DUZ)
 D CHKEQ^XTMUNIT(1,RET,"Incorrect return")
 D CHKEQ^XTMUNIT($P(^VA(200,DUZ,125),U,2),"","Incorrect user assigned list.")
 ;
 Q
 ;
XTENT ;
 ;;GETULST;Get assigned selection list
 ;;GETCLST;Get first list assigned to the clinic
 ;;VALLIST;Check list for invalid codes
 ;;ASSUSR;Assign selection list to users
 ;;REMUSR;Remove selection list from users
 Q

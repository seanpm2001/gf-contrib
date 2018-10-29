concrete MiniGrammarSom of MiniGrammar = open MiniResSom, Prelude in {


  lincat
    Utt = SS ;
    Adv = SS ;
    Pol = {s : Str ; p : Bool} ;
    S  = SS ;
    Cl = {s : Bool => Str} ;
    VP = Verb ** { compl : Agreement => {p1,p2 : Str} ; isPred : Bool } ;
    AP = Adjective ;
    CN = CNoun ;
    NP,
    Pron = MiniResSom.NP ;
    Det = MiniResSom.Det ;
    -- Conj = {s : Str} ;
    -- Prep = {s : Str} ;
    V = Verb ;
    V2 = Verb2 ;
    A = Adjective ;
    N = Noun ;
    -- PN = ProperName ;

  lin
    UttS s = s ;
    UttNP np = { s = np.s ! Abs } ;
    UsePresCl pol cl = {
      s = cl.s ! pol.p
      } ;

    PredVP np vp = let compl = vp.compl ! np.a in {
      s = \\b =>
           if_then_Str np.isPron [] (np.s ! Nom)
        ++ compl.p1
        ++ case <b,vp.isPred,np.a> of { --sentence type marker + subj. pronoun
             <True,True,Sg3 _> => "waa" ;
             _                 => stmarker ! np.a ! b } -- marker+pronoun contract
            -- _                 => stmarkerNoContr ! np.a ! b }
        ++ compl.p2            -- object pronoun for pronouns, empty for nouns
	      ++ vp.s ! VPres np.a b -- the verb inflected
      } ;

    UseV v = v ** { compl = \\_ => <[],[]> ; isPred = False } ;

    ComplV2 v2 np = v2 ** {
      compl = \\a => case np.isPron of {
                True  => <[], v2.c2 ++ np.s ! Abs> ;
                False => <v2.c2 ++ np.s ! Abs, []> } ;
      isPred = False
      } ;
    UseAP ap = {
      compl = \\a => <[], ap.s ! AF (getNum a) Abs> ;
      s = copula.s ; isPred = True
      } ;
    AdvVP vp adv = vp ** {
      compl = \\x => <(vp.compl ! x).p1, (vp.compl ! x).p2 ++ adv.s> } ;

    DetCN det cn = useN cn ** {
      s = \\c =>
           let cns = case <c,det.d> of {
                       <Nom,Indef Sg> => cn.s ! IndefNom ; -- special form
                       <Nom,Def x A>  => cn.s ! Def x U ; ---- TODO check if makes sense
                       _              => cn.s ! det.d }
            in cns
            ++ det.s ! c
            ++ cn.mod ! getNum (getAgr det.d Masc) ! c ;
      a = getAgr det.d cn.g ;
      stm = stmarker ! getAgr det.d cn.g
      } ;
    -- UsePN pn = {
    --   s = \\_ => pn.s ;
    --   a = Agr Sg Per3
    --   } ;
    UsePron p =
      p ;
    MassNP cn = useN cn ** {
      s = table { Nom => cn.s ! IndefNom ++ cn.mod ! Sg ! Nom ;
                  Abs => cn.s ! Indef Sg ++ cn.mod ! Sg ! Abs }
      } ;

    UseN = useN ;

    a_Det = mkDet [] "uu" [] (Indef Sg) ;
    aPl_Det = mkDet [] "ay" [] (Indef Pl) ;
    the_Det = mkDet "a" "kani" "tani" (Def Sg A) ;
    thePl_Det = mkDet "a" "kuwan" "kuwan" (Def Pl A) ;

-- Bestämdhetskongruens
-- När ett substantiv binds som attribut till ett annat substantiv med hjälp av
-- den attributiva kortformen ah som är av kopulaverbet yahay är, då måste båda
-- substantiven vara antingen obestämda eller bestämda. Man kan alltså säga att
-- de kongruerar med avseende på bestämdhet
    AdjCN ap cn = cn ** {
      s = table { IndefNom => cn.s ! Indef Sg ; -- When an adjective is added, it will carry subject marker.
                  x        => cn.s ! x } ;
      mod = \\n,c => cn.mod ! n ! Abs ++ ap.s ! AF n c
      } ;

    PositA a = a ;

{-    PrepNP prep np = {s = prep.s ++ np.s ! Abs} ;

    CoordS conj a b = {s = a.s ++ conj.s ++ b.s} ; -}

    PPos  = {s = [] ; p = True} ;
    PNeg  = {s = [] ; p = False} ;
{-
    and_Conj = {s = "and"} ;
    or_Conj = {s = "or"} ;

    every_Det = {s = "every" ; n = Sg} ;

    in_Prep = {s = "in"} ;
    on_Prep = {s = "on"} ;
    with_Prep = {s = "with"} ;
-}
    i_Pron = {
      s = table {Nom => "aan" ; Abs => "i"} ;
      a = Sg1 ; isPron = True ; sp = "aniga" ;
      stm = table { True => "waan" ; False => "maan" }
      } ;
    youSg_Pron = {
      s = table {Nom => "aad" ; Abs => "ku"} ;
      a = Sg2 ; isPron = True ; sp = "adiga" ;
      stm = table { True => "waad" ; False => "maad" }
      } ;
    he_Pron = {
      s = table {Nom => "uu" ; Abs => []} ;
      a = Sg3 Masc ; isPron = True ; sp = "isaga" ;
      stm = table { True => "wuu" ; False => "muu" }
      } ;
    she_Pron = {
      s = table {Nom => "ay" ; Abs => []} ;
      a = Sg3 Fem ; isPron = True ; sp = "iyada" ;
      stm = table { True => "way" ; False => "may" }
      } ;
    we_Pron = {
      s = table {Nom => "aan" ; Abs => "na"} ;
      a = Pl1 Incl ; isPron = True ; sp = "innaga" ;
      stm = table { True => "waan" ; False => "maan" }
      } ;
    youPl_Pron = {
      s = table {Nom => "aad" ; Abs => "idin"} ;
      a =  Pl2 ; isPron = True ; sp = "idinka" ;
      stm = table { True => "waad" ; False => "maad" }
      } ;
    they_Pron = {
      s = table {Nom => "aay" ; Abs => []} ;
      a = Pl3 ; isPron = True ; sp = "iyaga" ;
      stm = table { True => "way" ; False => "may" }
      } ;

}

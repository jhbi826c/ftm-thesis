%% Thesis class for the Chair of Joining Technology and Assembly, TU Dresden.
%% Wraps tudscrbook. lang=en (default) or lang=de picks the document language,
%% remaining options are handed through, e.g.
%% \documentclass[lang=de,BCOR=10mm]{ftmthesis}
%%
%% Provides
%%   \iflang{<german>}{<english>}
%%   \makeabstract{<german>}{<english>}
%%   \makeacronyms                       list of the \newacronym entries
%%   \makeacknowledgment                unnumbered chapter, text follows
%%   \tudlogoscale, \tudlogoshift        size and offset of the TUD wordmark

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ftmthesis}[2026/09/04 v1.0 FTM thesis class based on tudscrbook]

\RequirePackage{etoolbox}
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=ftm,prefix=ftm@}
\DeclareStringOption[en]{lang}

\PassOptionsToClass{%
  BCOR=5mm,%
  twoside,%
  numbers=noenddot,%
  parskip=half,%
  listof=totoc,%
  cdgeometry=symmetric,%
  cd=barcolor,%
  chapterpage=false,%
  cdmath=false,%
  slantedgreek=standard,%
  captions=tableheading,%
  subjectthesis=on,%
  cdfont=false%
}{tudscrbook}

\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{tudscrbook}}
\ProcessKeyvalOptions*

\ifboolexpr{ test {\ifdefstring{\ftm@lang}{de}} or test {\ifdefstring{\ftm@lang}{en}} }{}{%
  \ClassError{ftmthesis}{Unknown value `\ftm@lang' for option lang}%
    {Use lang=de or lang=en.}%
}

%% \iflang{<german>}{<english>}
\DeclareRobustCommand*\iflang[2]{\ifdefstring{\ftm@lang}{de}{#1}{#2}}

\iflang{\def\ftm@languages{english,ngerman}}{\def\ftm@languages{ngerman,english}}
\edef\@classoptionslist{\ftm@languages%
  \ifx\@classoptionslist\@empty\else,\@classoptionslist\fi}
\PassOptionsToClass{\ftm@languages}{tudscrbook}
\LoadClass{tudscrbook}

\RequirePackage{tudscrcolor}
\RequirePackage{graphicx}

%% Head of the title page. A later \faculty, \chair or \headlogo in the document
%% overrides it.
\faculty{%
  \makebox[\textwidth][l]{%
    \iflang{Fakultät Maschinenwesen}{Faculty of Mechanical Science and Engineering}%
    \hfill
    \tud@head@font@light
    \iflang{Professur für Fügetechnik und Montage}{Chair of Joining Technology and Assembly}%
  }%
}
\institute{}
\chair{}
\headlogo{figs/ftm-logo.pdf}

%% \makeabstract{<german>}{<english>} -- both are printed, the language of the
%% thesis first, only that one goes into the table of contents.
\newcommand\makeabstract[2]{%
  \TUDoption{abstract}{section,multiple,nottotoc}%
  \begin{abstract}[pagestyle=empty.tudheadings]%
    \addchaptertocentry{}{\abstractname}%
    \iflang{#1}{#2}%
    \iflang{\nextabstract[english]}{\nextabstract[ngerman]}%
    \iflang{#2}{#1}%
  \end{abstract}%
}

%% TUD wordmark. \tudlogoscale is a fraction of the height the class reserves,
%% \tudlogoshift moves it right; both may be redefined in the document.
\newcommand*\ftm@tudlogo{figs/tud-logo.pdf}
\newcommand*\tudlogoscale{0.75}
\newcommand*\tudlogoshift{1.5em}

\AtBeginDocument{%
  \def\@tempa{%
    \hspace*{\tudlogoshift}%
    \includegraphics[keepaspectratio,height=\tudlogoscale\tud@dim@mainlogoheight]%
  }%
  \tud@savelayerbox{main@black}{\@tempa{\ftm@tudlogo}}%
  \tud@savelayerbox{main@HKS41}{\@tempa{\ftm@tudlogo}}%
  \tud@savelayerbox{main@white}{\@tempa{\ftm@tudlogo}}%
}

%% Corporate blue of tudscr, used for headings and links -- black instead.
\definecolor{HKS41}{HTML}{000000}
\colorlet{cddarkblue}{HKS41}

%% Colour of the bar carrying faculty and chair.
\definecolor{ftmblue}{RGB}{10,42,81}
\AtBeginDocument{%
  \ModifyLayer[contents={%
    \ifnum\tud@head@bar@num>\@ne\relax
      \color{ftmblue}%
      \tud@setdim\@tempdima{\ht\strutbox-\tud@dim@barheight}%
      \ifdim\@tempdima<\z@\relax\tud@setdim\@tempdima{\z@}\fi%
      \raisebox{\@tempdima}{\rule{\layerwidth}{\layerheight}}%
    \fi%
  }]{tudheadings.head.bar}%
}

%% Packages
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}

\DeclareFontShape{T1}{cmss}{sb}{n}{<->ssub*cmss/m/n}{}
\DeclareFontShape{T1}{cmss}{sbx}{n}{<->ssub*cmss/bx/n}{}
\DeclareFontShape{T1}{cmss}{sb}{it}{<->ssub*cmss/m/sl}{}
\DeclareFontShape{T1}{cmss}{sbx}{it}{<->ssub*cmss/bx/sl}{}

\expandafter\RequirePackage\expandafter[\ftm@languages]{babel}
\RequirePackage{csquotes}

\RequirePackage{isodate}
\RequirePackage{blindtext}

\RequirePackage{setspace}
\RequirePackage{scrhack}

\RequirePackage{enumitem}\setlist{noitemsep}
\RequirePackage{microtype}

\RequirePackage{amsmath}
\RequirePackage{amsfonts}
\RequirePackage{bm}
\RequirePackage[b]{esvect}

\RequirePackage{multirow}
\RequirePackage{booktabs}
\setlength\heavyrulewidth{0.25ex}
\RequirePackage{longtable}

\RequirePackage[font=footnotesize,format=plain,labelfont=bf]{caption}
\RequirePackage{subcaption}

\RequirePackage[bottom,hang,flushmargin]{footmisc}
\renewcommand\hangfootparindent{1em}

\RequirePackage[backend=biber,style=numeric,sorting=none]{biblatex}

\RequirePackage{listings}
\definecolor{KeywordBlue}{cmyk}{0.88,0.77,0,0}
\definecolor{CommentGreen}{cmyk}{0.87,0.24,1.0,0.13}
\lstset{basicstyle=\scriptsize\ttfamily, language=C, commentstyle=\color{CommentGreen}, keywordstyle=\ttfamily\color{KeywordBlue}, backgroundcolor =\color[rgb]{0.95,0.95,0.95}, breaklines=true,literate={\\\%}{{\textcolor{black}{\\\%}}}1}

\RequirePackage[%
  pdfusetitle,%
  hypertexnames=false,%
  colorlinks=true,%
  urlcolor=.,%
  citecolor=.,%
  linkcolor=.,%
  pdfstartview=FitV,%
  pdfdisplaydoctitle=true,%
  hyperfootnotes=false%
]{hyperref}
\urlstyle{same}

\iflang{\def\ftm@pdfiflang#1#2{#1}}{\def\ftm@pdfiflang#1#2{#2}}
\pdfstringdefDisableCommands{\let\iflang\ftm@pdfiflang}

\RequirePackage{tracklang}
\def\@tracklang@warn#1{}

%% Acronyms. \newacronym may be used in the preamble or in the document, as long
%% as every entry is defined before \makeacronyms.
\RequirePackage[acronym,nomain,nonumberlist,nogroupskip,nolangwarn,toc,section=chapter,style=long,docdef=restricted]{glossaries-extra}
\setabbreviationstyle[acronym]{long-short}
\makenoidxglossaries

%% \makeacronyms -- the list of acronyms.
\newcommand\makeacronyms{%
  \begingroup
    \setlength\LTleft{0.95em}%
    \setlength\LTright{\fill}%
    \setlength\glsdescwidth{0.8\linewidth}%
    \printnoidxglossary[%
      type=\acronymtype,%
      title={\iflang{Abkürzungsverzeichnis}{Abbreviations}},%
      toctitle={\iflang{Abkürzungsverzeichnis}{Abbreviations}}%
    ]%
  \endgroup
}

\RequirePackage{cleveref}

%% \makeacknowledgment -- unnumbered chapter, the text follows in the document.
\newcommand\makeacknowledgment{%
  \addchap{\iflang{Danksagung}{Acknowledgment}}%
}

%% Layout
\pdfminorversion=7

\renewcommand*\@pnumwidth{2.1em}
\renewcommand*\@tocrmarg{3.1em}

\KOMAoptions{toc=chapterentrydotfill}
\setstretch{1.1}
\frenchspacing

\clubpenalty          = 9999
\widowpenalty         = 9999
\displaywidowpenalty  = 1602
\brokenpenalty        = 4999
\pretolerance         = 1100
\tolerance            = 100

\setcounter{topnumber}{2}
\setcounter{bottomnumber}{2}
\setcounter{totalnumber}{4}
\renewcommand{\topfraction}{0.85}
\renewcommand{\bottomfraction}{0.85}
\renewcommand{\floatpagefraction}{0.7}
\renewcommand{\textfraction}{0.1}
\setlength{\floatsep}{5pt plus 2pt minus 2pt}

\endinput

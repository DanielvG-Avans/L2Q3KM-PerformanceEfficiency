%% avans.cls --- Avans University of Applied Sciences (Avans Hogeschool)
%% Research Paper Style — Brand Identity Compliant
%%
%% Based on Avans Hogeschool Visual Style Guide — Brand Identity document.
%%
%% Key brand elements:
%%   Primary red     : #CF0A2C  (Avans Red — dominant accent colour)
%%   Near-black      : #1A1A1A  (body text, bold display text)
%%   Mid-grey        : #6B6B6B  (secondary text, subtitles, metadata)
%%   Rule grey       : #E0E0E0  (thin horizontal dividers)
%%   White           : #FFFFFF  (background/surfaces)
%%   Primary typeface: Helvetica Neue (headings) -> TeX Gyre Heros (free substitute)
%%   Body typeface   : Georgia or humanist serif -> TeX Gyre Pagella (Palatino)
%%   Layout          : generous white space, red punctuation, clean hierarchy
%%
%% USAGE
%%   \documentclass[<options>]{avans}
%%
%% CLASS OPTIONS
%%   dutch          --- sets babel to dutch (default: english)
%%   twocolumn      --- two-column body (passed through to article)
%%   final | draft  --- passed through
%%   11pt | 12pt    --- font size (default 11pt)
%%
%% REQUIRED METADATA COMMANDS (in preamble)
%%   \title{...}
%%   \author{...}
%%   \studentnumber{...}  (optional)
%%   \course{...}         (optional)
%%   \programme{...}      (optional --- e.g. "HBO-ICT")
%%   \supervisor{...}     (optional)
%%   \date{...}           (defaults to \today)
%%   \institution{Avans University of Applied Sciences}  (pre-set, override if needed)
%%
%% EXAMPLE MINIMAL DOCUMENT
%%   \documentclass{avans}
%%   \title{My Research Paper}
%%   \author{Jane Doe}
%%   \studentnumber{12345678}
%%   \course{Research Methods}
%%   \programme{HBO-ICT}
%%   \supervisor{Dr. J. Supervisor}
%%   \begin{document}
%%   \maketitle
%%   \tableofcontents
%%   \section{Introduction}
%%   ...
%%   \end{document}
%%
%% --------------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{avans}[2025/01/01 v1.0 Avans Hogeschool Research Paper Style]

% ============================================================
%  0. OPTION HANDLING
% ============================================================
\newif\if@dutch
\@dutchfalse

\DeclareOption{dutch}{\@dutchtrue}
\DeclareOption{english}{\@dutchfalse}

% Pass common options straight to the base class
\DeclareOption{twocolumn}{\PassOptionsToClass{twocolumn}{article}}
\DeclareOption{onecolumn}{\PassOptionsToClass{onecolumn}{article}}
\DeclareOption{draft}{\PassOptionsToClass{draft}{article}}
\DeclareOption{final}{\PassOptionsToClass{final}{article}}
\DeclareOption{10pt}{\PassOptionsToClass{10pt}{article}}
\DeclareOption{11pt}{\PassOptionsToClass{11pt}{article}}
\DeclareOption{12pt}{\PassOptionsToClass{12pt}{article}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

\ExecuteOptions{11pt}
\ProcessOptions\relax

\LoadClass[a4paper]{article}

% ============================================================
%  1. PACKAGES
% ============================================================

\RequirePackage{ifthen}
\RequirePackage{iftex}

% --- Encoding & language ---
% Keep legacy encoding packages for pdfTeX; modern engines are UTF-8 native.
\ifPDFTeX
  \RequirePackage[T1]{fontenc}
  \RequirePackage[utf8]{inputenc}
\fi
\if@dutch
	\RequirePackage[dutch]{babel}
\else
	\RequirePackage[english]{babel}
\fi

% --- Fonts ---
% TeX Gyre Heros: free Frutiger/Helvetica substitute --- used for all headings
\RequirePackage{tgheros}
% TeX Gyre Pagella: Palatino-like serif --- comfortable for long body text
\RequirePackage{tgpagella}
% Mono: inconsolata for code listings
\RequirePackage[scaled=0.88]{inconsolata}

% Set sans-serif as the default document font family (matches Avans digital style)
% Use TeX Gyre Pagella (serif) for body text for readability
\renewcommand{\familydefault}{\rmdefault}  % serif body by default

% Micro-typography
\RequirePackage[final]{microtype}
\microtypesetup{nopatch=footnote}

% --- Page geometry ---
% Avans huisstijl emphasises generous white space; inner margin slightly wider for binding
\RequirePackage[
	a4paper,
	top    = 25mm,
	bottom = 30mm,
	left   = 30mm,
	right  = 25mm,
	headsep = 10mm,
	footskip = 15mm
]{geometry}
\setlength{\headheight}{21.01996pt}

% --- Colour ---
\RequirePackage[table,dvipsnames]{xcolor}

%% Brand colours — Avans Hogeschool Visual Style Guide
%% https://avans.nl/ brand identity
\definecolor{AvansRed}{HTML}{CF0A2C}        % Primary Red — punctuation and accents
\definecolor{AvansBlack}{HTML}{1A1A1A}      % Near-black — body text, bold display
\definecolor{AvansGray}{HTML}{6B6B6B}       % Mid-grey — secondary text, metadata
\definecolor{AvansRuleGray}{HTML}{E0E0E0}   % Rule grey — thin dividers only
\definecolor{AvansWhite}{HTML}{FFFFFF}      % White — backgrounds

% --- Headers & footers ---
\RequirePackage{fancyhdr}

% --- Titling helpers ---
\RequirePackage{titlesec}
\RequirePackage{titletoc}

% --- Hyperlinks ---
\RequirePackage[
	colorlinks = true,
	linkcolor  = AvansRed,
	citecolor  = AvansRed,
	urlcolor   = AvansRed
]{hyperref}

% --- Graphics ---
\RequirePackage{graphicx}

% --- Captions ---
% Captions: label bold sans red, text regular small sans grey
\RequirePackage[
	font      = {small, sf},
	labelfont = {bf},
	labelsep  = period,
	format    = plain,
	justification = raggedright
]{caption}
\DeclareCaptionFont{avansred}{\color{AvansRed}}
\DeclareCaptionFont{avansgray}{\color{AvansGray}}
\captionsetup{labelfont={avansred}, textfont={avansgray}}

% --- Tables ---
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{tabularx}
\RequirePackage{longtable}

% --- Lists ---
\RequirePackage{enumitem}
\setlist[itemize]{leftmargin=*, nosep, topsep=4pt}
\setlist[enumerate]{leftmargin=*, nosep, topsep=4pt}

% --- Mathematics ---
\RequirePackage{amsmath}
\RequirePackage{amssymb}

% --- Code listings ---
\RequirePackage{listings}
\lstset{
	basicstyle   = \ttfamily\small,
	keywordstyle = \bfseries\color{AvansRed},
	commentstyle = \itshape\color{AvansGray},
	stringstyle  = \color{AvansRed!80!black},
	numbers      = left,
	numberstyle  = \tiny\color{AvansGray},
	numbersep    = 8pt,
	frame        = single,
	rulecolor    = \color{AvansMidGray},
	backgroundcolor = \color{AvansLightGray},
	breaklines   = true,
	breakatwhitespace = true,
	showstringspaces = false,
	tabsize      = 2,
}

% --- Miscellaneous utilities ---
\RequirePackage{setspace}
\RequirePackage{parskip}
\RequirePackage{ragged2e}
\RequirePackage{csquotes}
\RequirePackage{xspace}
\RequirePackage{lastpage}

% ============================================================
%  2. METADATA STORAGE
% ============================================================
\newcommand{\@studentnumber}{}
\newcommand{\studentnumber}[1]{\renewcommand{\@studentnumber}{#1}}

\newcommand{\@course}{}
\newcommand{\course}[1]{\renewcommand{\@course}{#1}}

\newcommand{\@programme}{}
\newcommand{\programme}[1]{\renewcommand{\@programme}{#1}}

\newcommand{\@supervisor}{}
\newcommand{\supervisor}[1]{\renewcommand{\@supervisor}{#1}}

\newcommand{\@institution}{Avans University of Applied Sciences}
\newcommand{\institution}[1]{\renewcommand{\@institution}{#1}}

% ============================================================
%  3. TYPOGRAPHY --- BODY TEXT
% ============================================================
\setlength{\parindent}{0pt}
\setlength{\parskip}{8pt plus 2pt minus 1pt}
\setstretch{1.15}

% ============================================================
%  4. SECTION HEADINGS — Avans Visual Style Guide compliant
%
%  H1 (section)      : Bold sans, large, #1A1A1A, number in #CF0A2C, 
%                      followed by thin #E0E0E0 rule
%  H2 (subsection)   : Bold sans, normal size, #1A1A1A, grey number
%  H3 (subsubsection): Italic sans, normal size, #6B6B6B
% ============================================================

%  \section  -----------------------------------------------
\titleformat{\section}
	{\Large\bfseries\sffamily\color{AvansBlack}}  % format: dark text
	{\color{AvansRed}\thesection}                  % label: red number
	{0.75em}                                       % sep
	{}                                             % before-code
	[\vspace{4pt}\color{AvansRuleGray}\rule{\linewidth}{0.8pt}]  % after: thin grey rule

\titlespacing*{\section}{0pt}{16pt plus 4pt minus 2pt}{8pt plus 2pt}

%  \subsection  --------------------------------------------
\titleformat{\subsection}
	{\large\bfseries\sffamily\color{AvansBlack}}   % format
	{\color{AvansGray}\thesubsection}              % label: grey number
	{0.75em}                                       % sep
	{}                                             % before-code
	[]                                             % no under-rule for H2

\titlespacing*{\subsection}{0pt}{14pt plus 3pt minus 2pt}{6pt plus 1pt}

%  \subsubsection  -----------------------------------------
\titleformat{\subsubsection}
	{\normalsize\itshape\sffamily\color{AvansGray}}
	{\thesubsubsection}
	{0.75em}
	{}

\titlespacing*{\subsubsection}{0pt}{10pt plus 2pt minus 1pt}{4pt}

%  \paragraph  ---------------------------------------------
\titleformat{\paragraph}[runin]
	{\normalsize\bfseries\sffamily\color{AvansRed}}
	{}
	{0pt}
	{}[.\enspace]

\titlespacing*{\paragraph}{0pt}{8pt}{4pt}

% ============================================================
%  5. TABLE OF CONTENTS — styled
% ============================================================
\contentsmargin{0pt}

\titlecontents{section}
	[0pt]                                          % left
	{\vspace{3pt}\bfseries\sffamily}              % above-code
	{\contentslabel{1.8em}}                        % numbered
	{\hspace*{-1.8em}}                             % unnumbered
	{\hfill\bfseries\color{AvansRed}\contentspage} % filler-page

\titlecontents{subsection}
	[1.2em]
	{\vspace{1pt}\sffamily}
	{\contentslabel{2.2em}}
	{\hspace*{-2.2em}}
	{\enspace\color{AvansGray}\titlerule*[6pt]{.}\contentspage}

\titlecontents{subsubsection}
	[2.8em]
	{\small\sffamily\color{AvansGray}}
	{\contentslabel{2.6em}}
	{\hspace*{-2.6em}}
	{\enspace\titlerule*[6pt]{.}\contentspage}

% Rename ToC heading if Dutch
\if@dutch
	\addto\captionsdutch{\renewcommand{\contentsname}{Inhoudsopgave}}
\fi

% ============================================================
%  6. HEADER & FOOTER — Avans Style Guide compliant
%
%  Header: section left (small mid-grey) | "Avans Hogeschool" right
%          Thin red rule below
%  Footer: page number centred (small mid-grey)
% ============================================================
\pagestyle{fancy}
\fancyhf{}

% Top: thin red rule (#CF0A2C, 0.6pt per guide)
\renewcommand{\headrulewidth}{0.6pt}
\renewcommand{\headrule}{%
	\vspace{-3pt}%
	\color{AvansRed}\rule{\linewidth}{0.6pt}%
}

% Header left: section name (small, mid-grey, sans)
\fancyhead[L]{%
	\small\sffamily\color{AvansGray}\leftmark
}

% Header right: institution (small, mid-grey, sans)
\fancyhead[R]{%
	\small\sffamily\color{AvansGray}Avans Hogeschool
}

% Footer: no rule, just page number centred
\renewcommand{\footrulewidth}{0pt}

% Footer centred: page number (small, mid-grey, sans)
\fancyfoot[C]{%
	\small\sffamily\color{AvansGray}\thepage
}

% Plain style for first pages of sections (cover, TOC)
\fancypagestyle{plain}{%
	\fancyhf{}%
	\fancyfoot[C]{\small\sffamily\color{AvansGray}\thepage}%
	\renewcommand{\headrulewidth}{0pt}%
	\renewcommand{\footrulewidth}{0pt}%
}

% ============================================================
%  7. TITLE PAGE — Avans Visual Style Guide compliant
%
%  1. Solid red (#CF0A2C) bar at top
%  2. Thick red rule (2.5pt)
%  3. Title (bold sans, large, dark)
%  4. Thin closing rule (0.8pt)
%  5. Metadata block below
%  6. Footer with institution and URL
% ============================================================
\renewcommand{\maketitle}{%
	\hypersetup{pageanchor=false}%
	\begin{titlepage}
		\thispagestyle{empty}
		
		% --- Bar 1: Solid Avans Red top bar (white institution name) ---
		\noindent
		\colorbox{AvansRed}{%
			\parbox[c][14mm]{\dimexpr\textwidth-2\fboxsep\relax}{%
				\hspace*{5mm}%
				\textcolor{white}{\sffamily\bfseries\large\@institution}%
				\hfill%
				\ifthenelse{\equal{\@course}{}}{}{%
					\textcolor{white}{\sffamily\bfseries\large\@course}%
					\hspace*{5mm}%
				}%
			}%
		}\par
		
		\vspace*{12mm}

		% --- Thick red rule (2.5pt) ---
		\color{AvansRed}\rule{\linewidth}{2.5pt}
		\color{AvansBlack}
		\vspace*{18mm}

		% --- Title (bold sans, large, dark) ---
		{\fontsize{32}{40}\selectfont\sffamily\bfseries\color{AvansBlack}\@title\par}
		
		% --- Programme info (if present) ---
		\ifthenelse{\equal{\@programme}{}}{}{%
			\vspace{6pt}%
			{\normalsize\sffamily\color{AvansGray}\@programme\par}%
		}%
		
		\vspace{16mm}

		% --- Thin red rule closes title block (0.8pt) ---
		{\color{AvansRed}\rule{\linewidth}{0.8pt}}
		\vspace{16mm}

		% --- Author block ---
		{\Large\sffamily\bfseries\color{AvansBlack}\@author}\\[4pt]
		\ifthenelse{\equal{\@studentnumber}{}}{}{%
			{\small\sffamily\color{AvansGray}%
				\if@dutch Studentnummer\else Student Number\fi:
				\@studentnumber}\\[3pt]%
		}%
		\ifthenelse{\equal{\@supervisor}{}}{}{%
			{\small\sffamily\color{AvansGray}%
				\if@dutch Begeleider\else Supervisor\fi:
				\@supervisor}\\[3pt]%
		}%
		{\small\sffamily\color{AvansGray}%
			\if@dutch Datum\else Date\fi:
			\@date}%

		\vfill

		% --- Footer: institution left, URL right ---
		{\color{AvansRuleGray}\rule{\linewidth}{0.8pt}}
		\vspace*{4pt}
		\noindent
		{\small\sffamily\color{AvansGray}\@institution}%
		\hfill%
		{\small\sffamily\color{AvansGray}avans.nl}

	\end{titlepage}%
	\hypersetup{pageanchor=true}%
	\setcounter{page}{1}%
}

% ============================================================
%  8. ABSTRACT ENVIRONMENT
% ============================================================
\renewenvironment{abstract}{%
	\vspace*{8pt}%
	\noindent{\sffamily\small\bfseries\color{AvansRed}%
		\if@dutch Samenvatting\else Abstract\fi}%
	\par\vspace{4pt}%
	\noindent{\color{AvansRuleGray}\rule{\linewidth}{0.8pt}}%
	\vspace{6pt}%
	\small\rmfamily\color{AvansBlack}%
	\setstretch{1.1}%
	\ignorespaces
}{%
	\vspace{8pt}\par%
	}


% ============================================================
%  9. KEYWORD COMMAND
% ============================================================
\newcommand{\keywords}[1]{%
	\vspace{4pt}%
	\noindent{\sffamily\small\bfseries\color{AvansGray}%
		\if@dutch Sleutelwoorden\else Keywords\fi:\enspace}%
	{\sffamily\small\color{AvansGray}#1}%
	\par\vspace{8pt}%
}

% ============================================================
%  10. TABLE STYLES — Avans Visual Style Guide compliant
%
%  Header: bold sans, small, CAPS, #6B6B6B (grey). No background color.
%  Rules: horizontal only (top, header, bottom) in #E0E0E0
%  Rows: white background, no zebra, no vertical rules
% ============================================================

% Configure booktabs rules to use guide colours
\let\@old@toprule\toprule
\let\@old@midrule\midrule
\let\@old@bottomrule\bottomrule

\renewcommand{\toprule}{\color{AvansRuleGray}\specialrule{0.8pt}{0pt}{2pt}\color{AvansBlack}}
\renewcommand{\midrule}{\color{AvansRuleGray}\specialrule{0.8pt}{2pt}{2pt}\color{AvansBlack}}
\renewcommand{\bottomrule}{\color{AvansRuleGray}\specialrule{0.8pt}{2pt}{0pt}\color{AvansBlack}}

% Table header style command
\newcommand{\tableheadrow}{%
	\rowcolor{white}%
	\bfseries\sffamily\small\color{AvansGray}%
}

% ============================================================
%  11. CALLOUT / INFO BOX ENVIRONMENTS
%
%  infobox   : left red border (#CF0A2C) — important callouts
%  notebox   : left grey border (#6B6B6B) — secondary notes
% ============================================================
\RequirePackage{mdframed}

\newmdenv[
	topline    = false,
	bottomline = false,
	rightline  = false,
	leftline   = true,
	linewidth  = 4pt,
	linecolor  = AvansRed,
	backgroundcolor = white,
	innerleftmargin  = 12pt,
	innerrightmargin = 8pt,
	innertopmargin   = 8pt,
	innerbottommargin= 8pt,
	skipabove  = 10pt,
	skipbelow  = 10pt,
]{avans@infobox}

\newenvironment{infobox}[1][]{%
	\begin{avans@infobox}%
	\ifthenelse{\equal{#1}{}}{}{%
		{\sffamily\bfseries\color{AvansRed}#1}\\[4pt]%
	}%
	\sffamily\small\color{AvansBlack}%
}{%
	\end{avans@infobox}%
}

% Note box (grey border for secondary callouts)
\newmdenv[
	topline    = false,
	bottomline = false,
	rightline  = false,
	leftline   = true,
	linewidth  = 4pt,
	linecolor  = AvansGray,
	backgroundcolor = white,
	innerleftmargin  = 12pt,
	innerrightmargin = 8pt,
	innertopmargin   = 8pt,
	innerbottommargin= 8pt,
	skipabove  = 10pt,
	skipbelow  = 10pt,
]{avans@notebox}

\newenvironment{notebox}[1][]{%
	\begin{avans@notebox}%
	\ifthenelse{\equal{#1}{}}{}{%
		{\sffamily\bfseries\color{AvansGray}#1}\\[4pt]%
	}%
	\sffamily\small\color{AvansBlack}%
}{%
	\end{avans@notebox}%
}

% ============================================================
%  12. BIBLIOGRAPHY HEADING
% ============================================================
\if@dutch
	\AtBeginDocument{\renewcommand{\refname}{Literatuurlijst}}
	\AtBeginDocument{\renewcommand{\bibname}{Literatuurlijst}}
\fi

% ============================================================
%  13. HYPERREF METADATA HOOK
% ============================================================
\AtBeginDocument{%
	\hypersetup{%
		pdftitle  = {\@title},
		pdfauthor = {\@author},
		pdfsubject= {\@course},
	}%
}

% ============================================================
%  END OF CLASS
% ============================================================
\endinput

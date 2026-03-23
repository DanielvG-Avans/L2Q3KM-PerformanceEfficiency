%% avans.cls --- Avans University of Applied Sciences (Avans Hogeschool)
%% Research Paper Style
%%
%% Based on publicly available Avans Hogeschool brand guidelines
%% (Huisstijlwijzer / Huisstijlgids, editie september 2020).
%%
%% Key brand elements reproduced:
%%   Primary colour  : Avans Rood  #C6002A  (PMS 1935, CMYK 0/100/57/5)
%%   Primary typeface: Frutiger -> substituted by TeX Gyre Heros (free, metric-compatible)
%%   Fallback body   : TeX Gyre Pagella (Palatino-like; readable for long reports)
%%   Layout          : generous white space, red rule accents, clean chapter/section heads
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

\ExecuteOptions{11pt}
\ProcessOptions\relax

\LoadClass[a4paper]{article}

% ============================================================
%  1. PACKAGES
% ============================================================

\RequirePackage{ifthen}
\RequirePackage{ifpdf}

% --- Encoding & language ---
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
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
\renewcommand{\familydefault}{\sfdefault}

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
\setlength{\headheight}{20.1pt}

% --- Colour ---
\RequirePackage[table,dvipsnames]{xcolor}

%  Brand colours --- Avans Huisstijlwijzer
\definecolor{AvansRed}{HTML}{C6002A}        % Avans Rood  (PMS 1935 / HEX C6002A)
\definecolor{AvansBlack}{HTML}{1A1A1A}      % Near-black body text
\definecolor{AvansGray}{HTML}{6B6B6B}       % Secondary gray
\definecolor{AvansLightGray}{HTML}{F2F2F2}  % Background tint for table rows
\definecolor{AvansMidGray}{HTML}{CCCCCC}    % Subtle rules / borders

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
\RequirePackage[
	font      = {small, sf},
	labelfont = {bf},
	labelsep  = period,
	format    = plain,
	justification = raggedright
]{caption}
\DeclareCaptionFont{avansred}{\color{AvansRed}}
\captionsetup{labelfont={bf,avansred}}

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
%  4. SECTION HEADINGS --- Avans style
%     Large, sans-serif, Avans Rood, with a coloured rule below
% ============================================================

%  \section  -----------------------------------------------
\titleformat{\section}
	{\Large\bfseries\sffamily\color{AvansRed}}   % format
	{\thesection}                                  % label
	{0.75em}                                       % sep
	{}                                             % before-code
	[\vspace{2pt}\color{AvansRed}\rule{\linewidth}{1.5pt}]  % after-code

\titlespacing*{\section}{0pt}{18pt plus 4pt minus 2pt}{8pt plus 2pt}

%  \subsection  --------------------------------------------
\titleformat{\subsection}
	{\large\bfseries\sffamily\color{AvansBlack}}
	{\thesubsection}
	{0.75em}
	{}
	[\vspace{1pt}\color{AvansMidGray}\rule{\linewidth}{0.6pt}]

\titlespacing*{\subsection}{0pt}{14pt plus 3pt minus 2pt}{6pt plus 1pt}

%  \subsubsection  -----------------------------------------
\titleformat{\subsubsection}
	{\normalsize\bfseries\sffamily\color{AvansBlack}}
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
%  5. TABLE OF CONTENTS --- styled
% ============================================================
\contentsmargin{0pt}

\titlecontents{section}
	[0pt]                                          % left
	{\vspace{4pt}\bfseries\sffamily}              % above-code
	{\contentslabel{2.2em}}                        % numbered
	{\hspace*{-2.2em}}                             % unnumbered
	{\hfill\bfseries\color{AvansRed}\contentspage} % filler-page

\titlecontents{subsection}
	[1.5em]
	{\vspace{1pt}\sffamily}
	{\contentslabel{2.8em}}
	{\hspace*{-2.8em}}
	{\enspace\color{AvansGray}\titlerule*[6pt]{.}\contentspage}

\titlecontents{subsubsection}
	[3.5em]
	{\small\sffamily\color{AvansGray}}
	{\contentslabel{3.2em}}
	{\hspace*{-3.2em}}
	{\enspace\titlerule*[6pt]{.}\contentspage}

% Rename ToC heading if Dutch
\if@dutch
	\addto\captionsdutch{\renewcommand{\contentsname}{Inhoudsopgave}}
\fi

% ============================================================
%  6. HEADER & FOOTER
% ============================================================
\pagestyle{fancy}
\fancyhf{}

% Top red rule
\renewcommand{\headrulewidth}{1.5pt}
\renewcommand{\headrule}{%
	\vspace{-4pt}%
	\color{AvansRed}\rule{\linewidth}{1.5pt}%
}

% Header left: institution name in AvansRed
\fancyhead[L]{%
	\small\sffamily\bfseries\color{AvansRed}\@institution
}

% Header right: section name
\fancyhead[R]{%
	\small\sffamily\color{AvansGray}\leftmark
}

% Footer rule
\renewcommand{\footrulewidth}{0.4pt}
\renewcommand{\footrule}{%
	\color{AvansMidGray}\rule{\linewidth}{0.4pt}%
}

% Footer: author left, page number right
\fancyfoot[L]{%
	\small\sffamily\color{AvansGray}\@author
}
\fancyfoot[R]{%
	\small\sffamily\color{AvansGray}%
	\if@dutch Pagina~\else Page~\fi\thepage\,/\,\pageref{LastPage}
}

% Plain style for first pages of sections
\fancypagestyle{plain}{%
	\fancyhf{}%
	\fancyfoot[R]{\small\sffamily\color{AvansGray}\thepage}%
	\renewcommand{\headrulewidth}{0pt}%
	\renewcommand{\footrulewidth}{0.4pt}%
	\renewcommand{\footrule}{\color{AvansMidGray}\rule{\linewidth}{0.4pt}}%
}

% ============================================================
%  7. TITLE PAGE  (\maketitle)
% ============================================================
\renewcommand{\maketitle}{%
	\hypersetup{pageanchor=false}%
	\begin{titlepage}
		\thispagestyle{empty}
		% --- Top red bar (4 mm thick) ---
		\noindent
		\colorbox{AvansRed}{%
			\parbox[c][14mm]{\dimexpr\textwidth-2\fboxsep\relax}{%
				\hspace*{4mm}%
				\textcolor{white}{\sffamily\bfseries\large\@institution}%
			}%
		}\par
		\vspace*{20mm}

		% --- Programme / course badge ---
		\ifthenelse{\equal{\@programme}{}}{}{%
			\textcolor{AvansRed}{\sffamily\small\bfseries\MakeUppercase{\@programme}}\\[4pt]%
		}%
		\ifthenelse{\equal{\@course}{}}{}{%
			\textcolor{AvansGray}{\sffamily\small\@course}\\[2pt]%
		}%

		\vspace{10mm}

		% --- Title (very large, red) ---
		{\fontsize{28}{34}\selectfont\sffamily\bfseries\color{AvansRed}\@title\par}
		\vspace{6mm}

		% --- Red accent rule ---
		\color{AvansRed}\rule{\linewidth}{3pt}
		\color{black}
		\vspace{10mm}

		% --- Author block ---
		{\large\sffamily\bfseries\color{AvansBlack}\@author}\\[3pt]
		\ifthenelse{\equal{\@studentnumber}{}}{}{%
			{\small\sffamily\color{AvansGray}%
				\if@dutch Studentnummer\else Student number\fi:
				\@studentnumber}\\[2pt]%
		}%

		\vspace{8mm}

		% --- Meta table ---
		\begin{tabular}{@{}l@{\hspace{6mm}}l@{}}
			\ifthenelse{\equal{\@supervisor}{}}{}{%
				{\small\sffamily\color{AvansGray}%
					\if@dutch Begeleider\else Supervisor\fi}%
				& {\small\sffamily\color{AvansBlack}\@supervisor} \\[3pt]%
			}%
			{\small\sffamily\color{AvansGray}%
				\if@dutch Datum\else Date\fi}%
			& {\small\sffamily\color{AvansBlack}\@date} \\
		\end{tabular}

		\vfill

		% --- Bottom logo-area (wordmark in red) ---
		\noindent
		\rule{\linewidth}{0.6pt}\\[4pt]
		{\sffamily\bfseries\color{AvansRed}\large avans}%
		{\sffamily\color{AvansGray}\large\, hogeschool}
		\hfill
		{\small\sffamily\color{AvansGray}avans.nl}

	\end{titlepage}%
	\hypersetup{pageanchor=true}%
	\setcounter{page}{1}%
}

% ============================================================
%  8. ABSTRACT ENVIRONMENT
% ============================================================
\renewenvironment{abstract}{%
	\vspace*{4pt}%
	\noindent\colorbox{AvansLightGray}{%
		\parbox{\dimexpr\linewidth-2\fboxsep\relax}{%
			\vspace{6pt}%
			\noindent{\sffamily\bfseries\color{AvansRed}%
				\if@dutch Samenvatting\else Abstract\fi}%
			\par\vspace{4pt}%
			\small\sffamily\color{AvansBlack}%
			\setstretch{1.1}%
			\ignorespaces
		}%
	}%
}{%
		\vspace{6pt}%
	}
	\vspace{10pt}\par%


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
%  10. TABLE STYLES
% ============================================================
% Avans tables: white space, red header row, alternating light rows

% Colour for table header row background
\colorlet{AvansTableHead}{AvansRed}

% Convenience command for a styled header row
\newcommand{\tableheadrow}{\rowcolor{AvansTableHead}}

% Row colours via xcolor table
\rowcolors{2}{AvansLightGray}{white}

% Redefine \toprule / \midrule to use brand colour
\let\@old@toprule\toprule
\let\@old@midrule\midrule
\let\@old@bottomrule\bottomrule

\renewcommand{\toprule}{\color{AvansRed}\specialrule{1.5pt}{0pt}{3pt}\color{black}}
\renewcommand{\midrule}{\color{AvansMidGray}\specialrule{0.4pt}{2pt}{2pt}\color{black}}
\renewcommand{\bottomrule}{\color{AvansRed}\specialrule{1.5pt}{3pt}{0pt}\color{black}}

% ============================================================
%  11. CALLOUT / INFO BOX ENVIRONMENTS
% ============================================================
% \begin{infobox}[title] ... \end{infobox}
% Styled box with left red border --- useful for definitions, notes, etc.

\RequirePackage{mdframed}

\newmdenv[
	topline    = false,
	bottomline = false,
	rightline  = false,
	leftline   = true,
	linewidth  = 4pt,
	linecolor  = AvansRed,
	backgroundcolor = AvansLightGray,
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
	\sffamily\small%
}{%
	\end{avans@infobox}%
}

% Warning box (same but AvansGray border)
\newmdenv[
	topline    = false,
	bottomline = false,
	rightline  = false,
	leftline   = true,
	linewidth  = 4pt,
	linecolor  = AvansGray,
	backgroundcolor = AvansLightGray,
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
	\sffamily\small%
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

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{avans}[2026/03/24 v2.0 Avans-inspired report class]

\newif\if@dutch
\newif\if@english
\newif\if@print

\DeclareOption{dutch}{\@dutchtrue\@englishfalse}
\DeclareOption{english}{\@dutchfalse\@englishtrue}
\DeclareOption{print}{\@printtrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ExecuteOptions{english}
\ProcessOptions\relax

\LoadClass[12pt,a4paper]{article}

% Core packages
\RequirePackage{ifthen}
\RequirePackage{iftex}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\if@dutch
  \RequirePackage[dutch]{babel}
\else
  \RequirePackage[dutch,english]{babel}
\fi
\RequirePackage{helvet}
\RequirePackage{tgpagella}
\RequirePackage{microtype}
\RequirePackage{geometry}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{fancyhdr}
\RequirePackage[noindentafter]{titlesec}
\RequirePackage{titletoc}
\RequirePackage{setspace}
\RequirePackage{caption}
\RequirePackage{booktabs}
\RequirePackage{tabularx}
\RequirePackage{array}
\RequirePackage{ragged2e}
\RequirePackage{tikz}
\RequirePackage{etoolbox}
\RequirePackage{natbib}
\RequirePackage{csquotes}
\RequirePackage[pagebackref=true,plainpages=false]{hyperref}

% Brand palette (Avans-inspired)
\definecolor{avans-red}{HTML}{E11F26}
\definecolor{avans-black}{HTML}{111111}
\definecolor{avans-white}{HTML}{FFFFFF}
\definecolor{avans-gray}{HTML}{6B6B6B}
\definecolor{avans-light}{HTML}{F5F5F5}

\if@print
  \colorlet{accent}{black}
\else
  \colorlet{accent}{avans-red}
\fi

% Page and paragraph layout
\geometry{a4paper,left=30mm,right=30mm,top=28mm,bottom=30mm}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0.6em}
\setstretch{1.12}

% Hyperref appearance
\hypersetup{
  colorlinks=true,
  citecolor=accent,
  linkcolor=accent,
  urlcolor=accent
}

% Typography defaults: sans text with serif headings
\renewcommand*\familydefault{\sfdefault}
\newcommand*\avansheadingfont{\rmfamily\bfseries}

% Metadata fields
\newcommand*\@programme{}
\newcommand*\@supervisor{}
\newcommand*\@institution{}
\newcommand*\@keywords{}

\newcommand*\programme[1]{\gdef\@programme{#1}}
\newcommand*\supervisor[1]{\gdef\@supervisor{#1}}
\newcommand*\institution[1]{\gdef\@institution{#1}}
\newcommand*\keywords[1]{%
  \gdef\@keywords{#1}%
  \par\smallskip\noindent\textbf{Keywords:} #1%
}

% Table helper used in content files
\newcommand*\tablehead[1]{\textbf{#1}}

% Section styling
\titleformat{\section}
  {\Large\avansheadingfont}
  {\color{accent}\thesection}
  {0.7em}
  {\color{avans-black}}
  [\vspace{0.2em}\color{accent}\titlerule]

\titleformat{\subsection}
  {\large\avansheadingfont}
  {\color{accent}\thesubsection}
  {0.6em}
  {\color{avans-black}}

\titleformat{\subsubsection}
  {\normalsize\avansheadingfont}
  {\color{accent}\thesubsubsection}
  {0.5em}
  {\color{avans-black}}

\titlespacing*{\section}{0pt}{1.5\baselineskip}{0.5\baselineskip}
\titlespacing*{\subsection}{0pt}{1.2\baselineskip}{0.3\baselineskip}
\titlespacing*{\subsubsection}{0pt}{0.9\baselineskip}{0.2\baselineskip}

% TOC styling
\renewcommand{\contentsname}{Table of Contents}
\dottedcontents{section}[0em]{\avansheadingfont}{2.2em}{0.8pc}
\dottedcontents{subsection}[2.8em]{}{2.6em}{0.8pc}

% Header/footer styling
\setlength{\headheight}{25pt}
\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\small\color{avans-gray}\nouppercase{\leftmark}}
\fancyhead[R]{\small\avansheadingfont\thepage}
\renewcommand*\headrulewidth{0.4pt}
\renewcommand*\headrule{\hbox to\headwidth{\color{accent}\leaders\hrule height \headrulewidth\hfill}}
\renewcommand*\footrulewidth{0pt}

\renewcommand*\sectionmark[1]{\markboth{\thesection\enspace #1}{}}

\newcommand*\setheader[1]{\markboth{#1}{#1}}

% Title page
\renewcommand*\maketitle{%
  \begin{titlepage}
    \hypersetup{pageanchor=false}
    \newgeometry{left=0mm,right=0mm,top=0mm,bottom=0mm}
    \thispagestyle{empty}

    \begin{tikzpicture}[remember picture,overlay]
      \fill[avans-black] (current page.south west) rectangle (current page.north east);
      \fill[accent] (current page.north west) rectangle ([yshift=-4.8cm]current page.north east);

      % Angular white shape for a contemporary cover feel.
      \fill[avans-white] ([xshift=2.8cm,yshift=-8.2cm]current page.north west)
        -- ([xshift=14.0cm,yshift=-8.2cm]current page.north west)
        -- ([xshift=7.8cm,yshift=-13.8cm]current page.north west)
        -- ([xshift=2.8cm,yshift=-13.8cm]current page.north west)
        -- cycle;

      \node[anchor=north west,text=avans-white,font=\sffamily\bfseries\fontsize{16}{18}\selectfont]
        at ([xshift=2.2cm,yshift=-1.6cm]current page.north west) {AVANS THE FUTURE};

      \node[anchor=north west,text=avans-white,text width=14.8cm,align=left,
            font=\rmfamily\bfseries\fontsize{30}{34}\selectfont]
        at ([xshift=2.2cm,yshift=-6.1cm]current page.north west) {\@title};

      \node[anchor=north west,text=avans-black,text width=10.4cm,align=left,
            font=\sffamily\bfseries\fontsize{14}{17}\selectfont]
        at ([xshift=3.3cm,yshift=-9.1cm]current page.north west)
        {\ifx\@programme\@empty\else Programme: \@programme\\\fi
         \ifx\@supervisor\@empty\else Supervisor: \@supervisor\fi};

      \node[anchor=south west,text=avans-white,text width=14.8cm,align=left,
            font=\sffamily\fontsize{13}{16}\selectfont]
        at ([xshift=2.2cm,yshift=2.0cm]current page.south west)
        {\@author\\\ifx\@institution\@empty\else\@institution\\\fi\@date};
    \end{tikzpicture}

    \null
    \restoregeometry
    \hypersetup{pageanchor=true}
  \end{titlepage}
}

% Figure/table caption style
\captionsetup{font=small,labelfont=bf,labelsep=period}

% Abstract style hook
\AtBeginEnvironment{abstract}{\small}

% Lists in accent color
\renewcommand*\labelitemi{\color{accent}\textbullet}
\renewcommand*\labelitemii{\color{accent}--}

\endinput

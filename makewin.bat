@echo off


rem �����ڹ���Ա����µ�·������
cd /d "%~dp0" 

title CQUThesis�Զ����������

set flag=%1
if %flag%x == x (
  set flag=thesis
)

if %flag%x == thesisx (
  call:thesis
  goto :EOF
)
if %flag%x == thesisxx (
  call:thesisx
  goto :EOF
)
if %flag%x == docx (
  call:extract
  call:document
  goto :EOF
)
if %flag%x == cleanx (
  call:cleanaux
  goto :EOF
)
if %flag%x == cleanpdfx (
  call:cleanpdf
  goto :EOF
)
if %flag%x == cleanallx (
  call:cleanaux
  call:cleanpdf
  goto :EOF
)
if %flag%x == extractx (
  call:extract
  goto :EOF
)
if %flag%x == allx (
  call:thesis
  call:document
  goto :EOF
)
if %flag%x == buildx (
  call:extract
  call:thesis
  goto :EOF
)
if %flag%x == buildxx (
  call:extract
  call:thesis
  call:document
  goto :EOF
)

:help
  echo *************************************************************
  echo CQUThesis�Զ����������Windows��
  echo �����ѧ��ҵ���LaTeXģ�壺 https://github.com/nanmu42/CQUThesis
  echo (C) 2016-2017 ����� ����LPPL 1.3Э�鿪Դ
  echo ������������Դ��Github��Liam0205/sduthesis���ڴ���л��
  echo *************************************************************
  echo *
  echo �����÷���
  echo        makewin [����]
  echo ������
  echo   help      չʾ��������Ϣ
  echo   thesis    ͨ��latexmk���ܣ����ٵر������ģ�˫�����޲���ʱĬ�����У�
  echo   thesisx   ����һ�����������ı��루������ϵͳ��û��װlatexmk������һ������Ƽ�������ģ�
  echo   doc       ����CQUThesis�û��ĵ�
  echo   clean     ��������.aux�ļ�
  echo   cleanpdf  ��������.pdf�ļ�
  echo   cleanall  ��������.aux�ļ��Լ�.pdf�ļ�
  echo   extract   ��.dtx�ļ�����ȡģ��
  echo   all       thesis + doc
  echo   build     extract + thesis
  echo   buildx    extract + thesis + doc
  echo *
  echo ***********************Happy TeXing**************************
  echo ************************д����죡***************************
goto :EOF

:checkfiles
  IF NOT EXIST cquthesis.cls call:extract
  IF NOT EXIST cquthesis.cfg call:extract
goto :EOF

:thesis
  call:checkfiles
  echo ��ȷ������ϵͳ����ȷ����latexmk...
  echo ʹ��latexmk���ܱ���������...
  latexmk -xelatex main.tex
  echo *                                       *
  echo *********̫���ˣ����ı�����ɣ�**********
  echo *                                       *
  goto pauseIfDoubleClicked

:thesisx
  call:checkfiles
  echo ���ı�����......
  xelatex main.tex
  bibtex main.tex
  xelatex main.tex
  xelatex main.tex
  xelatex main.tex
  echo *                                                    *
  echo ***************̫���ˣ����ı�����ɣ�*****************
  echo ��ʾ���������ٶȽ������Ƽ�ʹ��makewin thesis���б��롣
  echo *                                                    *
goto :EOF

:cleanaux
  echo ��������.aux�ļ���...
  for %%i in (*.aux *.bbl *.equ *.glo *.gls *.hd *.idx *.ilg *.ind *.lof *.lot *.out *.blg *.log *.thm *.toc *.synctex.gz *.lofEN *.lotEN *.equEN) do (
    del %%i
  )
  echo .aux�ļ�������ɡ�
goto :EOF

:cleanpdf
  echo ��������.pdf�ļ���...
  for %%i in (*.pdf) do (
    del %%i
  )
  echo .pdf�ļ�������ɡ�
goto :EOF

:clean_all
  call:cleanaux
  call:cleanpdf
goto :EOF

:extract
  echo ������ȡCQUThesisģ���ļ�...
  latex cquthesis.ins
  echo *                             *
  echo *******ģ���ļ���ȡ���********
  echo *                             *
goto :EOF

:document
  echo ����CQUThesis�û��ĵ���...
  set cmode=-interaction=batchmode
  xelatex cquthesis.dtx
  makeindex -s gind.ist -o cquthesis.ind cquthesis.idx
  makeindex -s gglo.ist -o cquthesis.gls cquthesis.glo
  xelatex cquthesis.dtx
  xelatex cquthesis.dtx
  xelatex cquthesis.dtx
  echo *                             *
  echo *******�û��ĵ��������********
  echo *                             *
goto :EOF

:pauseIfDoubleClicked
  setlocal enabledelayedexpansion
  set testl=%cmdcmdline:"=%
  set testr=!testl:%~nx0=!
  if not "%testl%" == "%testr%" pause                           *
goto :EOF

@echo off
setlocal
:: ------------------------------------------------------------------
:: Pedro Henrique Leite de Oliveira
:: 25114290043
:: ------------------------------------------------------------------
cls
echo ==================================================
echo     Iniciando Gestor de Arquivos Automatizado
echo ==================================================
echo.

::Definicao de Variaveis
SET "BasePath=%USERPROFILE%\Downloads\GestorArquivos"
SET "DocsPath=%BasePath%\Documentos"
SET "LogPath=%BasePath%\Logs"
SET "BackupPath=%BasePath%\Backups"
SET "LogFile=%LogPath%\atividade.log"
SET "ReportFile=%BasePath%\resumo_execucao.txt"

:: Variaveis de contagem
SET /A TotalPastas=0
SET /A TotalArquivos=0

::Variavel para o timestamp do backup
SET "BackupTimestamp="

::Criacao de Diretórios
echo [INFO] Verificando e criando estrutura de pastas...

::Criacao da pasta Base e Logs
IF NOT EXIST "%BasePath%\" (
    mkdir "%BasePath%"
    SET /A TotalPastas+=1
)
IF NOT EXIST "%LogPath%\" (
    mkdir "%LogPath%"
    SET /A TotalPastas+=1
    CALL :LogOperation "Criacao Pasta Logs" "Sucesso"
) ELSE (
    CALL :LogOperation "Verificacao Pasta Logs" "Ja existe"
)

::Criacao da pasta Documentos
IF NOT EXIST "%DocsPath%\" (
    mkdir "%DocsPath%"
    CALL :LogOperation "Criacao Pasta Documentos" "Sucesso"
    SET /A TotalPastas+=1
) ELSE (
    CALL :LogOperation "Verificacao Pasta Documentos" "Ja existe"
)

::Criacao da pasta Backups
IF NOT EXIST "%BackupPath%\" (
    mkdir "%BackupPath%"
    CALL :LogOperation "Criacao Pasta Backups" "Sucesso"
    SET /A TotalPastas+=1
) ELSE (
    CALL :LogOperation "Verificacao Pasta Backups" "Ja existe"
)
echo [INFO] Estrutura de pastas verificada.
echo.

::Criacao e Manipulacao de Arquivos
echo [INFO] Criando arquivos de demonstracao...

::Criar relatorio.txt
(
    echo Arquivo de Relatorio
    echo ========================
    echo Gerado em: %date% %time%
    echo Status: OK
) > "%DocsPath%\relatorio.txt"
CALL :LogOperation "Criacao Arquivo relatorio.txt" "Sucesso"
SET /A TotalArquivos+=1

::Criar dados.csv
(
    echo ID,Produto,Valor
    echo 1001,Mouse,79.90
    echo 1002,Teclado,149.90
) > "%DocsPath%\dados.csv"
CALL :LogOperation "Criacao Arquivo dados.csv" "Sucesso"
SET /A TotalArquivos+=1

::Criar config.ini
(
    echo [Servidor]
    echo host=192.168.0.1
    echo porta=3306
    echo [Usuario]
    echo user=admin
) > "%DocsPath%\config.ini"
CALL :LogOperation "Criacao Arquivo config.ini" "Sucesso"
SET /A TotalArquivos+=1

echo [INFO] Arquivos de demonstracao criados.
echo.

::Simulacao de Backup
echo [INFO] Iniciando processo de backup...
copy "%DocsPath%\*.*" "%BackupPath%\" > nul

::Verifica se a copia foi bem-sucedida
IF %ERRORLEVEL% EQU 0 (
    CALL :LogOperation "Copia de Backup (Documentos)" "Sucesso"
    :: Define o timestamp EXATO do backup
    SET "BackupTimestamp=%date% %time%"
    :: Cria o arquivo .bak com o registro
    echo Backup dos arquivos de Documentos concluido em: %BackupTimestamp% > "%BackupPath%\backup_completo.bak"
    CALL :LogOperation "Criacao Arquivo backup_completo.bak" "Sucesso"
    SET /A TotalArquivos+=1
) ELSE (
    CALL :LogOperation "Copia de Backup (Documentos)" "FALHA"
    SET "BackupTimestamp=N/A (FALHA)"
)
echo [INFO] Processo de backup concluido.
echo.

::Relatorio Final
echo [INFO] Gerando relatorio final de execucao...

(
    echo RELATORIO DE EXECUCAO
    echo ----------------------
    echo Total de arquivos criados: %TotalArquivos%
    echo Total de pastas criadas: %TotalPastas%
    echo Data/Hora do backup: %BackupTimestamp%
) > "%ReportFile%"

echo.
echo ==================================================
echo     Processo Concluido com Sucesso!
echo.
echo     - Log de atividades salvo em: %LogFile%
echo     - Relatorio final salvo em: %ReportFile%
echo ==================================================
echo.

goto :EndScript

::Sub-rotinas
:LogOperation
:: Sub-rotina para registrar atividades no arquivo de log.
:: %1 = Nome da Operacao
:: %2 = Status (Sucesso/Falha/Info)
echo %date% %time% - %~1 - %~2 >> "%LogFile%"
goto :eof

:EndScript
endlocal
pause
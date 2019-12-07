# Postgres

---

Copia seguranca nivel arquivo

- Instantaneo consistente
- Frozen snapshot (refaz os registros do WAL)
- Backup maior que o pg_dump

---

[WAL](http://pgdocptbr.sourceforge.net/pg80/backup-online.html)

Copia seguranca nivel Linha

WAL writer 	This process writes and flushes periodically the WAL data on the WAL buffer to persistent storage
The WAL mechanism was first implemented in version 7.1 to mitigate the impacts of server crashes. It also made possible the implementation of the Point-in-Time Recovery (PITR) and Streaming Replication (SR), both of which are described in Chapter 10 and Chapter 11 respectively. 

O WAL existe, principalmente, com a finalidade de fornecer segurança contra quedas: se o sistema cair, o banco de dados pode retornar a um estado consistente "refazendo" as entradas gravadas desde o último ponto de verificação.
Combinar a cópia de segurança do banco de dados no nível de sistema de arquivos, com cópia dos arquivos de segmento do WAL. Se for necessário fazer a recuperação, pode ser feita a recuperação da cópia de segurança do banco de dados no nível de sistema de arquivos e, depois, refeitas as alterações a partir da cópia dos arquivos de segmento do WAL, para trazer a restauração para o tempo presente.

Beneficios de utilizar esta tecnica:
- O ponto de partida não precisa ser uma cópia de segurança totalmente consistente. Toda inconsistência interna na cópia de segurança é corrigida quando o WAL é refeito (o que não é muito diferente do que acontece durante a recuperação de uma queda). Portanto, não é necessário um sistema operacional com capacidade de tirar instantâneos, basta apenas o tar, ou outra ferramenta semelhante.
- Como pode ser reunida uma seqüência indefinidamente longa de arquivos de segmento do WAL para serem refeitos, pode ser obtida uma cópia de segurança contínua simplesmente continuando a fazer cópias dos arquivos de segmento do WAL. Isto é particularmente útil para bancos de dados grandes, onde pode não ser conveniente fazer cópias de segurança completas regularmente.
- Não existe nada que diga que as entradas do WAL devem ser refeitas até o fim. Pode-se parar de refazer em qualquer ponto, e obter um instantâneo consistente do banco de dados como se tivesse sido tirado no instante da parada. Portanto, esta técnica suporta a recuperação para um determinado ponto no tempo: é possível restaurar voltando o banco de dados para o estado em que se encontrava a qualquer instante posterior ao da realização da cópia de segurança base.
- Se outra máquina, carregada com a mesma cópia de segurança base do banco de dados, for alimentada continuamente com a série de arquivos de segmento do WAL, será criado um sistema reserva à quente (hot standby): a qualquer instante esta outra máquina pode ser ativada com uma cópia quase atual do banco de dados.

Alta confiabilidade

**Para fazer uma recuperação bem-sucedida utilizando cópia de segurança em-linha, é necessária uma seqüência contínua de arquivos de segmento do WAL guardados, que venha desde, pelo menos, o instante em que foi feita a cópia de segurança base do banco de dados. Para começar, deve ser configurado e testado o procedimento para fazer cópia dos arquivos de segmento do WAL, antes de ser feita a cópia de segurança base do banco de dados. Assim sendo, primeiro será explicada a mecânica para fazer cópia dos arquivos de segmento do WAL.**

---

- The logical and physical structures of the WAL (transaction log)
- The internal layout of WAL data
- Writing of WAL data
- WAL writer process
- The checkpoint processing
- The database recovery processing
- Managing WAL segment files
- Continuous archiving

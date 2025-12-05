import fs from 'fs'; //Manipulação de diretórios e arquivos.
import fastcsv from 'fast-csv'; //Conversão para CSV.
import path from 'path'; //Obter caminho
import { pool } from '../database/db.js';//Conexão com o postgresql.

//Cria um vetor com o nome das tabelas que serão exportadas para arquivo CSV.
const tables = ["clientes", "mercadorias", "trajetos"]

//Função para exportar dados do banco PostgreSQL para CSV.
export async function exportCsv() {

    //Define o nome do diretório e o lugar onde vai ser criado.
    const exportDir = path.resolve("./exports");

    //Cria o diretório pegando o caminho, não dá erro se já existir diretório com mesmo nome.
    fs.mkdirSync(exportDir, { recursive: true });

    //Pega cada tabela do banco e exporta para CSV.
    for (const table of tables) {

        //Mensagem notificando exportação.
        console.log(`Exportando tabela ${table}...`);

        //Query utilizada para obter os dados da tabela especificada.
        const result = await pool.query(`SELECT * FROM ${table}`);

        //Define o nome final do arquivo CSV
        const outPutPath = path.join(exportDir, `${table}.csv`);

        //Cria leitor para os dados da selecionados no banco.
        const ws = fs.createWriteStream(outPutPath);

        //Lê os dados usando o leitor criado, retorna sucesso ("finish") ou erro ("error") 
        await new Promise((resolve,reject) => {
            fastcsv
                .write(result.rows, {headers:true, delimiter:","})
                .on("finish",resolve)
                .on("error",reject)
                .pipe(ws)
        });

        //Notifica aonde o CSV foi gerado.
        console.log(`CSV gerado em: ${outPutPath}`);
    }

    //Finaliza conexão com o banco.
    await pool.end();

    //Notifica fim do procedimento.
    console.log("Exportações concluídas.")
}

//Utilizado para execução direta (sem utilizar o npm run export-csv)
if (process.argv[1].includes("export-csv.js")) {
    exportCsv();
}
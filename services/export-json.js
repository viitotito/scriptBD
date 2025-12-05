import fs from 'fs'; //Manipulação de diretórios e arquivos.
import path from 'path'; //Obter caminho
import { pool } from '../database/db.js';//Conexão com o postgresql.

//Cria um vetor com o nome das tabelas que serão exportadas para arquivo CSV.
const tables = ["clientes", "mercadorias", "trajetos"]

//Função para exportar dados do banco PostgreSQL para CSV.
export async function exportJson() {

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

        //Pega os dados obtidos da consulta e converte para Json.
        const dataJson = await JSON.stringify(result.rows, null, 2)

        //Define o nome final do arquivo Json
        const outPutPath = path.join(exportDir, `${table}.json`);

        //Cria o arquivo json no caminho indicado.
        fs.writeFileSync(outPutPath,dataJson);

        //Notifica aonde o Json foi gerado.
        console.log(`Json gerado em: ${outPutPath}`);
    }

    //Finaliza conexão com o banco.
    await pool.end();

    //Notifica fim do procedimento.
    console.log("Exportações concluídas.")
}

//Utilizado para execução direta (sem utilizar o npm run export-csv)
if (process.argv[1].includes("export-json.js")) {
    exportJson();
}
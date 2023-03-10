#include <iostream>
#include <fstream>
#include <string>

using namespace std;

void leerLinea1(ifstream& infile, string& linea) {
    string elemento;
    linea = "";
    getline(infile, elemento, ';');
    linea += elemento + ';';
    getline(infile, elemento, ';');
    linea += elemento;
    getline(infile, elemento);
}




int main(){
    string linea;
    string namefile = "LigaHost.csv";
    string namefich = "Temporadas.csv";
    ifstream infile(namefile);
    ofstream outfile(namefich);
    int i = 0;
    if(!infile || !outfile) {
        cerr  << "NO SE PUDO ABRIR LOS ARCHIVOS" << endl;
        return 1;
    }
    leerLinea1(infile, linea);
    while(!infile.eof()){
        leerLinea1(infile, linea);
        outfile << i << ";" << linea << ";" << i << endl;
        i++;
    }
    infile.close();
    outfile.close();
    return 0;
}
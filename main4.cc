#include <iostream>
#include <fstream>
#include <string>

using namespace std;

void leerLinea1(ifstream& infile, string& linea) {
    string elemento;
    linea = "";
    getline(infile, elemento, ';');
    getline(infile, elemento, ';');
    getline(infile, elemento, ';');
    getline(infile, elemento, ';');
    getline(infile, elemento, ';');
    linea += elemento + ';';
    getline(infile, elemento, ';');
    getline(infile, elemento, ';');
    getline(infile, elemento, ';');
    getline(infile, elemento, ';');
    linea += elemento + ';';
    getline(infile, elemento, ';');
    linea += elemento + ';';
    getline(infile, elemento, ';');
    linea += elemento + ';';
    getline(infile, elemento, ';');
    linea += elemento + ';';
    getline(infile, elemento, ';');
    linea += elemento;
    getline(infile, elemento, ';');
    getline(infile, elemento, ';');
    getline(infile, elemento, ';');
    getline(infile, elemento);
}

int main(){
    string linea;
    string namefile = "LigaHost.csv";
    string namefich = "Equipos.csv";
    ifstream infile(namefile);
    ofstream outfile(namefich);
    if(!infile || !outfile) {
        cerr  << "NO SE PUDO ABRIR LOS ARCHIVOS" << endl;
        return 1;
    }
    leerLinea1(infile, linea);
    while(!infile.eof()){
        leerLinea1(infile, linea);
        outfile << linea << endl;
    }
    infile.close();
    outfile.close();
    return 0;
}
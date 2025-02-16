# ASC - Storage Management System

Acest proiect reprezintă o implementare a unui sistem minimal de gestiune a stocării pentru un sistem de operare. Scopul este de a simula gestionarea unui dispozitiv de stocare simplificat,
respectând cerințele enunțate în tema laboratorului de **Arhitectura Sistemelor de Calcul**.

## Caracteristici implementate

✅ **Implementare pentru cazul unidimensional**  
✅ **Operațiuni de gestionare a fișierelor:**
  - **ADD** – Adăugarea unui fișier într-un interval de blocuri consecutive
  - **GET** – Obținerea intervalului de stocare pentru un fișier
  - **DELETE** – Ștergerea unui fișier și eliberarea blocurilor de memorie
  - **DEFRAGMENTATION** – Reorganizarea memoriei pentru a elimina golurile

📌 **Reguli de stocare:**
  - Memoria are o capacitate fixă de **8MB** împărțită în blocuri de **8kB**
  - Fisierele trebuie să fie stocate **contiguu**, altfel nu pot fi salvate
  - Pot exista până la **255 de fișiere diferite**

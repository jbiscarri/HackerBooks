# Práctica iOS Fundamentos 
###Joan Biscarri


## Respuestas
---

**Mira en la ayuda en método


















AGTLibrary es delegado de AGTBook con lo que un cambio en isFavorite del AGTBook es notificado mediante el **delegado**
En cambio, para avisar al AGTLibraryTableViewController, lo hago vía notificación aunque podría ser la misma library (modelo) que avisara a la tabla para ser refrescada, he creido que encadenar 2 mensajes a delegados sería más complicado de seguir en un futuro.

---
**para que la tabla se actualice, usa el método




[tableView insertRowsAtIndexPaths:*arrayOfIndexPaths* withRowAnimation:*rowAnimation*];

[tableView deleteRowsAtIndexPaths:*arrayOfIndexPaths* withRowAnimation:*rowAnimation*];


[tableView endUpdates];

No creo que merezca la pena en este caso utilizarlo pero de cara a UX el efecto de actualización es más *fino*.

---
**Cuando el usuario cambia en la tabla el libro seleccionado, el AGTSimplePDFViewController
Con una NSNotification enviando como UserInfo el AGTBook.

## Extra
---
***Comentario:*** He añadido la carga de pdf e imágenes en otro thread de cara a mejorar algo la usabilidad de la App.
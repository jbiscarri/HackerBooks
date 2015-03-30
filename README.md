# Práctica iOS Fundamentos 
###Joan Biscarri


## Respuestas
---

**Mira en la ayuda en métodoisKindOfClass:ycomo usarlo para saber qué te han devuelto exactamente. ¿Qué otros métodos similareshay? ¿En qué se distingueisMemberOfClass:?**
Son métodos para realizar introspección en las instancias y saber cuál es su tipo o si hereda de la clase en cuestión. 
**isKindOfClass** devuelve YES en el caso de que mi objeto sea una instancia de la  clase o una instancia de cualquier clase que herede de esta clase.
En cambio, **isMemberOfClass** devuelve valor YES cuando el receptor es una instancia de la clase pasada.
Otros métodos para hacer instrospección podrían ser:***conformsToProtocol*** - Para saber si un objeto implementa un protocolo.
***respondsToSelector*** - Para saber si un objeto responde a un selector (mensaje).
---
**¿Donde guardarías estos datos?**
El JSON de donde se obtienen los libros lo guardaría dentro de la carpeta Documents puesto que son datos necesarios para la aplicación y deben estar disponibles siempre.
Las imágenes y PDF los guardaría en la carpeta Caches (Library/Caches).
---
**El ser o no favorito se indicará mediante una propiedad booleana de AGTBook(isFavorite) y esto se debe de guardar en el sistema de ficheros y recuperar de algunaforma. Es decir, esa información debe de persistir de alguna manera cuando se cierra laApp y cuando se abre.¿Cómo harías eso? ¿Se te ocurre más de una forma de hacerlo? Explica la decisión dediseño que hayas tomado.**
He guardado estos datos dentro de los User Defaults (un NSDictionary con KEY el nombre  del archivo pdf del libro y como VALUE un BOOL).
Cada vez que se añade o elimina un libro, modfifico este NSDictionary.
Otra posible manera es guardarlo directamente como una nueva KEY dentro del JSON que se descarga o, mejor, en CoreData.
---
**¿Cómo lo harías? Es decir, ¿cómo enviarías información de un AGTBooka un AGTLibraryTableViewController? ¿Se te ocurre más de una forma de hacerlo? ¿Cual teparece mejor? Explica tu elección.**
Se podría hacer utilizando un delegado o Notificaciones.
Para que el libro de añada el la sección favoritos debo avisar a AGTLibrary para que haga la gestión.
AGTLibrary es delegado de AGTBook con lo que un cambio en isFavorite del AGTBook es notificado mediante el **delegado**
En cambio, para avisar al AGTLibraryTableViewController, lo hago vía notificación aunque podría ser la misma library (modelo) que avisara a la tabla para ser refrescada, he creido que encadenar 2 mensajes a delegados sería más complicado de seguir en un futuro.

---
**para que la tabla se actualice, usa el métodoreloadDatadeUITableView. Esto haceque la tabla vuelva a pedir datos a su dataSource. ¿Es esto una aberración desde el puntode rendimiento (volver a cargar datos que en su mayoría ya estaban correctos)? Explica porqué no es así. ¿Hay una forma alternativa? ¿Cuando crees que vale la pena usarlo?**
La tabla actualiza únicamente las celdas que necesita (las visibles) por lo que el método de refresco es bastante eficiente.
Alguna posible manera alternativa sería actualizar celda a celda las visibles y, para el caso de los favoritos, añadir o eliminar las celdas manualmente:
[tableView beginUpdates];

[tableView insertRowsAtIndexPaths:*arrayOfIndexPaths* withRowAnimation:*rowAnimation*];

[tableView deleteRowsAtIndexPaths:*arrayOfIndexPaths* withRowAnimation:*rowAnimation*];


[tableView endUpdates];

No creo que merezca la pena en este caso utilizarlo pero de cara a UX el efecto de actualización es más *fino*.

---
**Cuando el usuario cambia en la tabla el libro seleccionado, el AGTSimplePDFViewControllerdebe de actualizarse. ¿Cómo lo harías?**
Con una NSNotification enviando como UserInfo el AGTBook.

## Extra
---
***Comentario:*** He añadido la carga de pdf e imágenes en otro thread de cara a mejorar algo la usabilidad de la App.
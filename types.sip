/*
 * Various conversions that are not made by PyQt4 default.
 */


/**
 * Convert QSet to and from a Python list.
 * (copied from PyKDE4, kdecore/typedefs.sip)
 */

%MappedType QSet<Poppler::Document::RenderBackend>
{
%TypeHeaderCode
#include <qset.h>
%End

%ConvertFromTypeCode
    // Create the list.
    PyObject *l;

    if ((l = PyList_New(sipCpp->size())) == NULL)
        return NULL;

    // Set the list elements.
    QSet<Poppler::Document::RenderBackend> set = *sipCpp;
    int i = 0;
    foreach (Poppler::Document::RenderBackend value, set)
    {
        PyObject *obj = PyInt_FromLong ((long) value);
        if (obj == NULL || PyList_SET_ITEM (l, i, obj) < 0)
        {
            Py_DECREF(l);

            if (obj)
                Py_DECREF(obj);

            return NULL;
        }

        Py_DECREF(obj);
        i++;
    }
   
    return l;
%End

%ConvertToTypeCode
    // Check the type if that is all that is required.
    if (sipIsErr == NULL)
    {
        if (!PyList_Check(sipPy))
            return 0;
    }

    // Check the type if that is all that is required.
    if (sipIsErr == NULL)
    {
        if (!PyList_Check(sipPy))
            return 0;
    }

    QSet<Poppler::Document::RenderBackend> *qs = new QSet<Poppler::Document::RenderBackend>;
 
    for (int i = 0; i < PyList_GET_SIZE(sipPy); ++i)
    {
        Poppler::Document::RenderBackend t = (Poppler::Document::RenderBackend)PyInt_AS_LONG(PyList_GET_ITEM (sipPy, i));
        *qs << t;
    }
 
    *sipCppPtr = qs;
 
    return sipGetState(sipTransferObj);
%End
};


/* kate: indent-width 4; space-indent on; hl c++; indent-mode cstyle; */

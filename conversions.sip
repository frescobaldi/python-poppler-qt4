/*
 * Various conversions that are not made by PyQt4 default.
 */


/**
 * Convert QSet to and from a Python list.
 * (copied from PyKDE4, kdecore/typedefs.sip)
 */

template <TYPE>
%MappedType QSet<TYPE>
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
    QSet<TYPE> set = *sipCpp;
    int i = 0;
    foreach (TYPE value, set)
    {
        PyObject *obj = sipConvertFromNewType(&value, sipType_TYPE, sipTransferObj);
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

        for (int i = 0; i < PyList_GET_SIZE(sipPy); ++i)
            if (!sipCanConvertToType(PyList_GET_ITEM (sipPy, i), sipType_TYPE, SIP_NOT_NONE))
                return 0;
    }

    QSet<TYPE> *qs = new QSet<TYPE>;
 
    for (int i = 0; i < PyList_GET_SIZE(sipPy); ++i)
    {
        int state;

        TYPE *t = reinterpret_cast<TYPE *>(sipConvertToType(PyList_GET_ITEM (sipPy, i), sipType_TYPE, sipTransferObj, SIP_NOT_NONE, &state, sipIsErr));
 
        if (*sipIsErr)
        {
            sipReleaseType(t, sipType_TYPE, state);

            delete qs;
            return 0;
        }

        *qs << *t;

        sipReleaseType(t, sipType_TYPE, state);
    }
 
    *sipCppPtr = qs;
 
    return sipGetState(sipTransferObj);
%End
};


/* kate: indent-width 4; space-indent on; hl c++; indent-mode cstyle; */

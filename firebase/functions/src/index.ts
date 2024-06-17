import {auth} from "firebase-functions";
import * as admin from "firebase-admin";
import {
  PartialWithFieldValue,
  QueryDocumentSnapshot,
  getFirestore,
} from "firebase-admin/firestore";

admin.initializeApp();

const converter = <T>() => ({
  toFirestore: (data: PartialWithFieldValue<T>) => data,
  fromFirestore: (snap: QueryDocumentSnapshot<T>) => snap.data() as T,
});

type User = {
  email?: string;
  emailVerified: boolean;
  displayName?: string;
  photoURL?: string;
  providers: string[];
};

const users = getFirestore()
  .collection("users")
  .withConverter(converter<User>());

export const createUserDocument = auth.user().onCreate(async (user) => {
  const userObject: User = {
    email: user.email,
    emailVerified: user.emailVerified,
    displayName: user.displayName,
    photoURL: user.photoURL,
    providers: user.providerData.map((provider) => provider.providerId),
  };

  return await users.doc(user.uid).set(userObject);
});

export const deleteUserDocument = auth.user().onDelete(async (user) => {
  return await users.doc(user.uid).delete();
});

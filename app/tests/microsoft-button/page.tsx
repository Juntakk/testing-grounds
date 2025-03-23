import { signIn, signOut, useSession } from "next-auth/react";
import { Button } from "@/components/ui/button";

const MicrosoftButton = () => {
  const { data: session } = useSession();

  const handleSignIn = () => {
    signIn("azure-ad");
  };
  const handleSignOut = async () => {
    await signOut({ redirect: true });
    window.location.href =
      "https://login.microsoftonline.com/common/oauth2/v2.0/logout?post_logout_redirect_uri=http://localhost:3000"; // Replace with your desired URL
  };
  return session ? (
    <div>
      <p>Welcome, {session.user?.name}!</p>
      <Button onClick={handleSignOut}>Sign Out</Button>
    </div>
  ) : (
    <Button onClick={handleSignIn}>Sign In with Microsoft</Button>
  );
};
export default MicrosoftButton;

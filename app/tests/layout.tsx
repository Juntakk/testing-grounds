import BackButton from "@/components/shared/BackButton";

export default function TestsLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <section className="w-screen h-screen flex flex-col items-center justify-center">
      <BackButton />
      {children}
    </section>
  );
}
